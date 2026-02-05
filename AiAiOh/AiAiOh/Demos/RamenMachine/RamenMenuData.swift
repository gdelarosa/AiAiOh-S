//
//  RamenMenuData.swift
//  AiAiOh
//  2/4/26
//  Populated ramen menu data 
//

import Foundation

struct RamenMenuData {
    static let items: [RamenMenuItem] = [
        RamenMenuItem(
            nameJP: "醤油ラーメン",
            nameEN: "Shoyu Ramen",
            priceUSD: "$8.50",
            priceJPY: "¥950"
        ),
        RamenMenuItem(
            nameJP: "味噌ラーメン",
            nameEN: "Miso Ramen",
            priceUSD: "$9.00",
            priceJPY: "¥1,000"
        ),
        RamenMenuItem(
            nameJP: "塩ラーメン",
            nameEN: "Shio Ramen",
            priceUSD: "$8.50",
            priceJPY: "¥950"
        ),
        RamenMenuItem(
            nameJP: "豚骨ラーメン",
            nameEN: "Tonkotsu Ramen",
            priceUSD: "$9.50",
            priceJPY: "¥1,100"
        ),
        RamenMenuItem(
            nameJP: "担々麺",
            nameEN: "Tantanmen",
            priceUSD: "$10.00",
            priceJPY: "¥1,200"
        ),
        RamenMenuItem(
            nameJP: "つけ麺",
            nameEN: "Tsukemen",
            priceUSD: "$10.50",
            priceJPY: "¥1,250"
        ),
        RamenMenuItem(
            nameJP: "辛味噌ラーメン",
            nameEN: "Spicy Miso Ramen",
            priceUSD: "$9.50",
            priceJPY: "¥1,100"
        ),
        RamenMenuItem(
            nameJP: "冷やし中華",
            nameEN: "Hiyashi Chuka",
            priceUSD: "$8.00",
            priceJPY: "¥900"
        )
    ]
}
