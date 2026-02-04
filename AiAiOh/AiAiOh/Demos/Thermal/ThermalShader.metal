//
//  ThermalShader.metal
//  AiAiOh
//
//  Metal shader for thermal heat visualization
//  Creates smooth, gradual heat diffusion in response to touch interactions
//  Renders thermal camera-style color gradients from cold blue to hot red
//

#include <metal_stdlib>
using namespace metal;

// MARK: - Data Structures

/// Heat source data structure matching Swift HeatSource
/// Must stay in sync with MetalHeatSource in ThermalHeatManager.swift
struct HeatSource {
    float2 position;      // Normalized position (0-1 range for x and y)
    float intensity;      // Current heat intensity (0 = cold, 1 = max heat)
    float radius;         // Radius of heat spread from center
    float age;            // Time in seconds since creation
};

/// Global shader parameters passed from Swift each frame
/// Must stay in sync with ThermalUniforms in ThermalHeatManager.swift
struct ThermalUniforms {
    float time;                // Current elapsed time (for animation)
    float2 resolution;         // Screen resolution in pixels
    int heatSourceCount;       // Number of active heat sources
    float baseTemperature;     // Ambient "cold" temperature (0-1)
    float maxTemperature;      // Maximum heat level allowed (0-1)
};

// MARK: - Color Mapping

/// Maps temperature value to thermal camera color
/// Creates classic thermal visualization: cold blue → cyan → green → yellow → orange → red
/// - Parameter temperature: Temperature value (0-1 where 0 is coldest, 1 is hottest)
/// - Returns: RGBA color representing the temperature
float4 thermalColor(float temperature) {
    // Clamp temperature to valid range
    float t = saturate(temperature);
    
    float4 color;
    
    if (t < 0.12) {
        // Deep black-blue: very cold idle state
        float localT = t / 0.12;
        color = mix(float4(0.015, 0.015, 0.06, 1.0),  // Near-black blue
                    float4(0.0, 0.04, 0.28, 1.0),      // Dark blue
                    localT);
    } else if (t < 0.25) {
        // Deep blue to medium blue: cold
        float localT = (t - 0.12) / 0.13;
        color = mix(float4(0.0, 0.04, 0.28, 1.0),      // Dark blue
                    float4(0.0, 0.15, 0.55, 1.0),      // Medium blue
                    localT);
    } else if (t < 0.38) {
        // Blue to cyan: cool
        float localT = (t - 0.25) / 0.13;
        color = mix(float4(0.0, 0.15, 0.55, 1.0),      // Medium blue
                    float4(0.0, 0.55, 0.65, 1.0),      // Cyan
                    localT);
    } else if (t < 0.50) {
        // Cyan to green: neutral/moderate
        float localT = (t - 0.38) / 0.12;
        color = mix(float4(0.0, 0.55, 0.65, 1.0),      // Cyan
                    float4(0.2, 0.72, 0.2, 1.0),       // Green
                    localT);
    } else if (t < 0.62) {
        // Green to yellow: warm
        float localT = (t - 0.50) / 0.12;
        color = mix(float4(0.2, 0.72, 0.2, 1.0),       // Green
                    float4(0.92, 0.88, 0.1, 1.0),      // Yellow
                    localT);
    } else if (t < 0.78) {
        // Yellow to orange: hot
        float localT = (t - 0.62) / 0.16;
        color = mix(float4(0.92, 0.88, 0.1, 1.0),      // Yellow
                    float4(1.0, 0.5, 0.0, 1.0),        // Orange
                    localT);
    } else if (t < 0.90) {
        // Orange to red: very hot
        float localT = (t - 0.78) / 0.12;
        color = mix(float4(1.0, 0.5, 0.0, 1.0),        // Orange
                    float4(1.0, 0.2, 0.0, 1.0),        // Red
                    localT);
    } else {
        // Red to bright red-white: maximum heat
        float localT = (t - 0.90) / 0.10;
        color = mix(float4(1.0, 0.2, 0.0, 1.0),        // Red
                    float4(1.0, 0.85, 0.7, 1.0),       // Red-white glow
                    localT);
    }
    
    return color;
}

// MARK: - Noise Functions

/// Simple hash function for pseudo-random values
/// Used as basis for noise generation
float hash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

/// Smooth value noise using Ken Perlin's improved smoothstep
/// Creates organic, natural-looking variation
float smoothNoise(float2 p) {
    float2 i = floor(p);  // Integer part
    float2 f = fract(p);  // Fractional part
    
    // Smootherstep interpolation (6t^5 - 15t^4 + 10t^3)
    // Creates very smooth transitions between noise values
    float2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
    
    // Sample noise at grid corners
    float a = hash(i);
    float b = hash(i + float2(1.0, 0.0));
    float c = hash(i + float2(0.0, 1.0));
    float d = hash(i + float2(1.0, 1.0));
    
    // Bilinear interpolation of corner values
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

/// Layered noise (fractal Brownian motion)
/// Combines multiple octaves of noise for organic, natural variation
/// - Parameters:
///   - p: Position to sample noise at
///   - time: Current time for animation
/// - Returns: Noise value (approximately 0-1)
float layeredNoise(float2 p, float time) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    
    // Very slow drift over time for subtle animation
    float2 drift = float2(time * 0.008, time * 0.006);
    
    // Accumulate 3 octaves of noise
    for (int i = 0; i < 3; i++) {
        value += amplitude * smoothNoise(p * frequency + drift);
        amplitude *= 0.5;   // Each octave contributes less
        frequency *= 2.0;   // Each octave has finer detail
        drift *= 1.3;       // Each octave drifts slightly faster
    }
    
    return value;
}

// MARK: - Heat Influence

/// Calculate heat influence from a single heat source at a given pixel
/// Creates soft, widespread heat blobs without sharp focal points
/// - Parameters:
///   - uv: Normalized screen coordinates (0-1)
///   - source: The heat source to evaluate
///   - time: Current time for animation
///   - aspectRatio: Screen aspect ratio for circular heat areas
/// - Returns: Heat contribution (0-1)
float softHeatInfluence(float2 uv, HeatSource source, float time, float aspectRatio) {
    // Skip sources with no intensity (optimization)
    if (source.intensity <= 0.001) return 0.0;
    
    // Adjust coordinates for aspect ratio to create circular heat areas
    float2 adjustedUV = float2(uv.x * aspectRatio, uv.y);
    float2 adjustedPos = float2(source.position.x * aspectRatio, source.position.y);
    
    // Calculate distance from heat source
    float2 diff = adjustedUV - adjustedPos;
    float distanceSq = dot(diff, diff);  // Squared distance (for optimization)
    float distance = sqrt(distanceSq);
    
    // Effective radius is much larger than source radius for soft, widespread heat
    float effectiveRadius = source.radius * 3.0;
    float radiusSq = effectiveRadius * effectiveRadius;
    
    // Gaussian-like falloff creates smooth, natural heat spread
    // e^(-d²/r²) creates a soft blob without sharp edges
    float falloff = exp(-distanceSq / (radiusSq * 0.5));
    
    // Additional edge softening with smoothstep
    // This makes the heat fade very gradually at the edges
    float edgeSoftness = smoothstep(effectiveRadius * 1.5, 0.0, distance);
    falloff *= edgeSoftness;
    
    // Add subtle organic distortion to the heat shape
    // This prevents perfect circles and creates natural variation
    float noiseOffset = layeredNoise(uv * 4.0 + source.position * 2.0, time * 0.5);
    float shapeDistortion = 1.0 + (noiseOffset - 0.5) * 0.3;
    
    // Apply distortion to falloff (not position, to avoid focal points)
    falloff *= shapeDistortion;
    
    return falloff * source.intensity;
}

// MARK: - Fragment Shader

/// Main fragment shader - runs once per pixel to determine color
/// Combines heat from all sources with thermal color mapping
fragment float4 thermalFragment(
    float4 position [[position]],                        // Pixel position
    constant ThermalUniforms &uniforms [[buffer(0)]],    // Global parameters
    constant HeatSource *heatSources [[buffer(1)]]       // Array of heat sources
) {
    // Convert pixel position to normalized coordinates (0-1)
    float2 uv = position.xy / uniforms.resolution;
    
    // Flip Y coordinate (Metal's origin is bottom-left, we want top-left)
    uv.y = 1.0 - uv.y;
    
    float aspectRatio = uniforms.resolution.x / uniforms.resolution.y;
    
    // Start with base "cold" temperature
    float temperature = uniforms.baseTemperature;
    
    // Add very subtle ambient "breathing" animation
    // Creates gentle movement in idle state
    float ambientBreath = layeredNoise(uv * 1.5, uniforms.time * 0.05);
    temperature += (ambientBreath - 0.5) * 0.015;
    
    // Accumulate heat from all active sources
    float totalHeat = 0.0;
    
    for (int i = 0; i < uniforms.heatSourceCount; i++) {
        HeatSource source = heatSources[i];
        float influence = softHeatInfluence(uv, source, uniforms.time, aspectRatio);
        totalHeat += influence;
    }
    
    // Soft clamp on accumulated heat to prevent oversaturation
    // f(x) = x / (1 + x*k) creates a smooth ceiling
    totalHeat = totalHeat / (1.0 + totalHeat * 0.3);
    
    // Apply accumulated heat to temperature
    temperature += totalHeat * 0.8;
    
    // Global warmth diffusion: when heat is present, slightly warm the surroundings
    // Creates subtle ambient glow around active heat areas
    if (totalHeat > 0.02) {
        float globalWarmth = totalHeat * 0.05;
        float warmthNoise = layeredNoise(uv * 2.0, uniforms.time * 0.08);
        temperature += globalWarmth * warmthNoise;
    }
    
    // Clamp to maximum temperature
    temperature = min(temperature, uniforms.maxTemperature);
    
    // Convert temperature value to thermal camera color
    float4 color = thermalColor(temperature);
    
    // Add very subtle film grain for texture
    float grain = hash(uv * uniforms.resolution + uniforms.time * 30.0);
    color.rgb += (grain - 0.5) * 0.008;
    
    return color;
}

// MARK: - Vertex Shader

/// Vertex output structure
struct VertexOut {
    float4 position [[position]];  // Clip-space position
    float2 texCoord;               // Texture coordinates
};

/// Vertex shader - generates full-screen quad
/// Creates 4 vertices forming 2 triangles to cover the entire screen
vertex VertexOut thermalVertex(
    uint vertexID [[vertex_id]],              // Vertex index (0-3)
    constant float2 *vertices [[buffer(0)]]   // Unused, we generate positions
) {
    VertexOut out;
    
    // Full-screen quad vertices in clip space (-1 to 1)
    // Forms a triangle strip: bottom-left, bottom-right, top-left, top-right
    float2 positions[4] = {
        float2(-1.0, -1.0),  // Bottom-left
        float2( 1.0, -1.0),  // Bottom-right
        float2(-1.0,  1.0),  // Top-left
        float2( 1.0,  1.0)   // Top-right
    };
    
    out.position = float4(positions[vertexID], 0.0, 1.0);
    
    // Convert from clip space (-1,1) to texture coordinates (0,1)
    out.texCoord = (positions[vertexID] + 1.0) * 0.5;
    
    return out;
}
