//
//  BubbleWrapShaders.swift
//  AiAiOh
//
//  Metal shader source for bubble wrap rendering
//

import Foundation

enum BubbleWrapShaders {
    static let source = """
    #include <metal_stdlib>
    using namespace metal;
    
    struct VertexOut {
        float4 position [[position]];
        float2 uv;
    };
    
    struct Uniforms {
        float width;
        float height;
        float time;
        float rows;
        float cols;
        float bubbleRadius;
        float bubbleSpacing;
        float padding;
    };
    
    struct BubbleData {
        float centerX;
        float centerY;
        float radius;
        float popProgress;
        float imperfectionSeed;
        float dent;
        float fadeProgress;
        float pad1;
    };
    
    // Noise functions for imperfections
    float hash(float2 p) {
        return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
    }
    
    float noise(float2 p) {
        float2 i = floor(p);
        float2 f = fract(p);
        f = f * f * (3.0 - 2.0 * f);
        
        float a = hash(i);
        float b = hash(i + float2(1.0, 0.0));
        float c = hash(i + float2(0.0, 1.0));
        float d = hash(i + float2(1.0, 1.0));
        
        return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
    }
    
    float fbm(float2 p) {
        float value = 0.0;
        float amplitude = 0.5;
        for (int i = 0; i < 4; i++) {
            value += amplitude * noise(p);
            p *= 2.0;
            amplitude *= 0.5;
        }
        return value;
    }
    
    vertex VertexOut bubbleVertex(uint vertexID [[vertex_id]]) {
        float2 positions[4] = {
            float2(-1.0, -1.0),
            float2( 1.0, -1.0),
            float2(-1.0,  1.0),
            float2( 1.0,  1.0)
        };
        
        VertexOut out;
        out.position = float4(positions[vertexID], 0.0, 1.0);
        out.uv = (positions[vertexID] + 1.0) * 0.5;
        out.uv.y = 1.0 - out.uv.y;
        return out;
    }
    
    fragment float4 bubbleFragment(VertexOut in [[stage_in]],
                                    constant Uniforms& uniforms [[buffer(0)]],
                                    constant BubbleData* bubbles [[buffer(1)]]) {
        float2 fragCoord = float2(in.uv.x * uniforms.width, in.uv.y * uniforms.height);
        
        // Start fully transparent - background image shows through
        float3 finalColor = float3(0.0);
        float finalAlpha = 0.0;
        
        int totalBubbles = int(uniforms.rows * uniforms.cols);
        
        // Key light (top-left, warm)
        float3 keyLightDir = normalize(float3(-0.6, -0.8, 1.0));
        float3 keyLightColor = float3(1.0, 0.98, 0.95);
        
        // Fill light (bottom-right, cool)
        float3 fillLightDir = normalize(float3(0.5, 0.6, 0.8));
        float3 fillLightColor = float3(0.9, 0.92, 1.0) * 0.3;
        
        // Rim light (back)
        float3 rimLightDir = normalize(float3(0.0, 0.0, -1.0));
        float3 rimLightColor = float3(1.0, 1.0, 1.0) * 0.15;
        
        // Process each bubble
        for (int i = 0; i < totalBubbles; i++) {
            BubbleData bubble = bubbles[i];
            
            float2 bubbleCenter = float2(bubble.centerX, bubble.centerY);
            float2 toBubble = fragCoord - bubbleCenter;
            float dist = length(toBubble);
            float radius = bubble.radius;
            
            if (dist > radius * 1.15) continue;
            
            float popProgress = bubble.popProgress;
            float fadeProgress = bubble.fadeProgress;
            float imperfection = bubble.imperfectionSeed;
            float dentAmount = bubble.dent;
            
            // Skip fully faded bubbles
            if (fadeProgress >= 1.0) continue;
            
            // Effective radius with pop animation
            float effectiveRadius = radius * (1.0 - popProgress * 0.3);
            
            // Normalized position within bubble
            float normalizedDist = dist / effectiveRadius;
            float2 normalizedPos = toBubble / effectiveRadius;
            
            // Bubble dome height (hemisphere)
            float heightFactor = 1.0 - popProgress;
            float domeHeight = sqrt(max(0.0, 1.0 - normalizedDist * normalizedDist)) * heightFactor;
            
            // Add micro imperfections
            float microNoise = fbm(fragCoord * 0.3 + imperfection * 100.0) * 0.05;
            domeHeight *= (1.0 - dentAmount - microNoise);
            
            // Surface normal
            float3 normal = normalize(float3(-normalizedPos * heightFactor, domeHeight + 0.01));
            
            // Add surface noise to normal for micro-scratches
            float scratchNoise = (noise(fragCoord * 2.0 + imperfection * 50.0) - 0.5) * 0.1;
            normal.xy += scratchNoise * (1.0 - popProgress);
            normal = normalize(normal);
            
            // View direction (orthographic, looking down)
            float3 viewDir = float3(0.0, 0.0, 1.0);
            
            // Fresnel effect
            float fresnel = pow(1.0 - max(dot(normal, viewDir), 0.0), 3.0);
            fresnel = mix(0.04, 1.0, fresnel); // F0 for plastic ~0.04
            
            // Specular highlights
            float3 halfVecKey = normalize(keyLightDir + viewDir);
            float specKey = pow(max(dot(normal, halfVecKey), 0.0), 80.0);
            
            float3 halfVecFill = normalize(fillLightDir + viewDir);
            float specFill = pow(max(dot(normal, halfVecFill), 0.0), 40.0);
            
            // Rim lighting
            float rim = pow(1.0 - max(dot(normal, viewDir), 0.0), 2.0) * 0.3;
            
            // Subtle chromatic aberration on highlights
            float chromatic = fresnel * 0.008 * (1.0 - popProgress);
            
            // Combine lighting
            float3 specular = specKey * keyLightColor + specFill * fillLightColor;
            specular *= (1.0 - popProgress * 0.8);
            
            // Bubble interior - subtle caustic-like effect
            float caustic = pow(max(domeHeight, 0.0), 2.0) * 0.1;
            
            float3 bubbleColor;
            float bubbleAlpha = 0.0;
            
            if (popProgress < 1.0 && normalizedDist < 1.0) {
                // Unpopped or popping bubble - transparent plastic overlay
                // Only render the specular highlights, fresnel, and plastic effects
                bubbleColor = float3(0.98, 0.99, 1.0); // Slight plastic tint
                bubbleColor += specular * 0.8;
                bubbleColor += rim * rimLightColor * 2.0;
                bubbleColor += caustic * keyLightColor * 0.3;
                
                // Add chromatic dispersion to highlights
                bubbleColor.r += chromatic * 2.0;
                bubbleColor.b -= chromatic;
                
                // Alpha based on fresnel (edges more visible) and specular
                bubbleAlpha = fresnel * 0.4 + specKey * 0.5 + specFill * 0.3;
                bubbleAlpha += rim * 0.3;
                
                // Edge darkening (plastic thickness)
                float edgeDarken = smoothstep(0.7, 1.0, normalizedDist);
                bubbleAlpha += edgeDarken * 0.2;
                
                // Condensation/internal texture adds slight opacity
                float condensation = fbm(fragCoord * 0.1 + imperfection * 30.0);
                bubbleAlpha += condensation * 0.08 * (1.0 - popProgress);
                
                // Clamp alpha
                bubbleAlpha = clamp(bubbleAlpha, 0.0, 0.85);
                
                finalColor = bubbleColor;
                finalAlpha = bubbleAlpha;
            }
            
            // Electric blue pop effect (during pop animation)
            if (popProgress > 0.0 && popProgress < 1.0) {
                // Electric blue color palette
                float3 electricBlue = float3(0.3, 0.7, 1.0);
                float3 electricCyan = float3(0.5, 0.95, 1.0);
                float3 electricWhite = float3(0.9, 0.95, 1.0);
                
                // Expand radius for the effect
                float effectRadius = radius * (1.0 + popProgress * 1.5);
                float effectDist = dist / effectRadius;
                
                // Central flash/glow - bright at start, fades out
                float flashIntensity = (1.0 - popProgress) * (1.0 - popProgress);
                float centralGlow = exp(-normalizedDist * 3.0) * flashIntensity * 1.5;
                
                // Electric arc lines radiating outward
                float angle = atan2(toBubble.y, toBubble.x);
                float numArcs = 8.0;
                
                // Animated arc rotation
                float arcAngle = angle + popProgress * 2.0 + imperfection * 6.28;
                
                // Create sharp electric lines
                float arcPattern = abs(sin(arcAngle * numArcs));
                arcPattern = pow(arcPattern, 20.0); // Sharp lines
                
                // Arcs expand outward during pop
                float arcRadius = popProgress * 1.8;
                float arcBand = smoothstep(arcRadius - 0.3, arcRadius, effectDist) * 
                               smoothstep(arcRadius + 0.4, arcRadius + 0.1, effectDist);
                
                // Add jagged noise to arcs for electric feel
                float arcNoise = noise(float2(angle * 10.0, popProgress * 20.0 + imperfection * 50.0));
                arcPattern *= (0.7 + arcNoise * 0.6);
                
                float arcIntensity = arcPattern * arcBand * (1.0 - popProgress * 0.7);
                
                // Secondary smaller sparks
                float sparkAngle = angle * 12.0 + popProgress * 8.0;
                float sparks = pow(abs(sin(sparkAngle)), 30.0);
                float sparkBand = smoothstep(arcRadius - 0.1, arcRadius + 0.1, effectDist) *
                                 smoothstep(arcRadius + 0.5, arcRadius + 0.2, effectDist);
                float sparkIntensity = sparks * sparkBand * (1.0 - popProgress) * 0.6;
                
                // Outer glow ring expanding
                float ringDist = abs(effectDist - popProgress * 1.2);
                float ring = exp(-ringDist * 8.0) * (1.0 - popProgress * 0.5);
                
                // Combine effects with color
                float3 popEffect = float3(0.0);
                popEffect += electricWhite * centralGlow;
                popEffect += mix(electricBlue, electricCyan, arcPattern) * arcIntensity;
                popEffect += electricCyan * sparkIntensity;
                popEffect += electricBlue * ring * 0.4;
                
                // Add subtle outer halo
                float halo = exp(-effectDist * 2.0) * (1.0 - popProgress) * 0.3;
                popEffect += electricBlue * halo;
                
                // Apply effect
                float effectAlpha = centralGlow + arcIntensity + sparkIntensity + ring * 0.3 + halo;
                effectAlpha = clamp(effectAlpha, 0.0, 1.0);
                
                // Blend with existing color
                finalColor = finalColor + popEffect;
                finalAlpha = max(finalAlpha, effectAlpha);
            }
            
            // Popped bubble - flattened disc that fades out
            if (popProgress >= 1.0 && normalizedDist < 1.1) {
                // Crumpled flat plastic
                float crumple = fbm(fragCoord * 0.2 + imperfection * 20.0) * 0.1;
                float3 poppedColor = float3(0.92, 0.92, 0.93);
                poppedColor -= crumple;
                
                // Concave dent in center
                float dentShadow = (1.0 - normalizedDist) * 0.08;
                poppedColor -= dentShadow;
                
                // Reduced gloss
                float poppedSpec = specKey * 0.3;
                poppedColor += poppedSpec;
                
                // Wrinkle lines radiating from center
                float angle = atan2(toBubble.y, toBubble.x);
                float wrinkles = sin(angle * 8.0 + imperfection * 6.28) * 0.02;
                wrinkles *= smoothstep(0.0, 0.5, normalizedDist);
                poppedColor -= wrinkles;
                
                // Popped bubbles are more opaque (crumpled plastic)
                float poppedAlpha = 0.5 + crumple * 0.3;
                poppedAlpha *= smoothstep(1.1, 0.9, normalizedDist);
                
                // Apply fade - smooth ease out curve
                float fadeCurve = 1.0 - fadeProgress * fadeProgress;
                poppedAlpha *= fadeCurve;
                
                finalColor = poppedColor;
                finalAlpha = poppedAlpha;
            }
            
            // Seam between bubbles (also fades with popped bubble)
            if (normalizedDist > 0.92 && normalizedDist < 1.15 && popProgress < 1.0) {
                float seamFactor = smoothstep(0.92, 1.0, normalizedDist);
                float3 seamColor = float3(0.94, 0.94, 0.95);
                
                // Seam crinkle
                float seamCrinkle = noise(fragCoord * 0.5) * 0.03;
                seamColor -= seamCrinkle;
                
                // Seams are slightly more visible
                float seamAlpha = seamFactor * 0.35;
                
                finalColor = mix(finalColor, seamColor, seamFactor * 0.7);
                finalAlpha = max(finalAlpha, seamAlpha);
            }
            
            // Ripple effect on neighboring plastic
            if (popProgress > 0.0 && popProgress < 1.0) {
                float ripple = sin(normalizedDist * 15.0 - popProgress * 10.0) * 0.02;
                ripple *= (1.0 - popProgress) * smoothstep(1.0, 1.5, normalizedDist);
                finalColor += ripple;
            }
        }
        
        return float4(finalColor, finalAlpha);
    }
    """
}
