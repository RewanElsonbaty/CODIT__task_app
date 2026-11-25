# User Flow Diagram - Gold Sales Product Addition

## ASCII Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                            HOME PAGE                                 │
│                     (home_page.dart)                                 │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Permission-based Menu with Cards                           │   │
│  │  - إدارة المستخدمين                                         │   │
│  │  - **مبيعات الذهب** ← User clicks here                      │   │
│  │  - إدارة المخزون                                            │   │
│  │  - إدارة الموردين                                           │   │
│  └────────────────────────────────────────────────────────────┘   │
└──────────────────────────────┬──────────────────────────────────────┘
                               │ Navigate
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       GOLD SALES PAGE                                │
│                   (gold_sale_page.dart)                              │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Sales Interface                                            │   │
│  │  - Current sale items list                                  │   │
│  │  - Total calculations                                       │   │
│  │  - **إضافة قطعة ذهب** button ← User clicks                 │   │
│  └────────────────────────────────────────────────────────────┘   │
└──────────────────────────────┬──────────────────────────────────────┘
                               │ Show Dialog
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│              PROGRESSIVE ADD GOLD DIALOG                             │
│         (progressive_add_gold_dialog.dart)                           │
│                                                                      │
│  ╔══════════════════════════════════════════════════════════════╗  │
│  ║  STAGE 0: CATEGORY SELECTION                                 ║  │
│  ╚══════════════════════════════════════════════════════════════╝  │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Search TextField: "ابحث عن الفئة بالحرف الأول"             │   │
│  │  User types: ر / R / خ                                       │   │
│  └────────────────────────────────────────────────────────────┘   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Categories Grid (Smart Filtered):                          │   │
│  │  💍 خواتم    ⛓️ سلاسل    📿 أساور    💎 أقراط             │   │
│  │  💑 دبل      ✨ أطقم     📌 توك      👣 غوايش              │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  User selects: خواتم ───────────────────────────────────────────▶  │
│                               │                                      │
│  ╔══════════════════════════════════════════════════════════════╗  │
│  ║  STAGE 1: TYPE SELECTION                                     ║  │
│  ╚══════════════════════════════════════════════════════════════╝  │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Title: "اختر نوع خواتم"                                    │   │
│  └────────────────────────────────────────────────────────────┘   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Types List:                                                 │   │
│  │  🌟 ذهب    - Gold      ───────────────────────▶            │   │
│  │  🌙 فضة    - Silver                                         │   │
│  │  💠 لازوردي - Lazurde                                       │   │
│  └────────────────────────────────────────────────────────────┘   │
│                               │                                      │
│  User selects: ذهب ──────────────────────────────────────────────▶ │
│                               │                                      │
│  ╔══════════════════════════════════════════════════════════════╗  │
│  ║  STAGE 2: SPECIFICATIONS FILTER                              ║  │
│  ╚══════════════════════════════════════════════════════════════╝  │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Karat Selection Chips:                                      │   │
│  │  [ الكل ]  [ 18 ]  [ 21✓]  [ 24 ]                          │   │
│  └────────────────────────────────────────────────────────────┘   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Weight Range Slider:                                        │   │
│  │  من 0.0 جم إلى 100.0 جم                                    │   │
│  │  ├─────●════════○─────┤                                     │   │
│  │  0                   100                                     │   │
│  └────────────────────────────────────────────────────────────┘   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  [ عرض النتائج ] ← User clicks                             │   │
│  └────────────────────────────────────────────────────────────┘   │
│                               │                                      │
│  Filters applied ─────────────────────────────────────────────────▶ │
│                               │                                      │
│  ╔══════════════════════════════════════════════════════════════╗  │
│  ║  STAGE 3: PRODUCT RESULTS                                    ║  │
│  ╚══════════════════════════════════════════════════════════════╝  │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Filtered Products Grid:                                     │   │
│  │                                                              │   │
│  │  ┌─────────────────────┐  ┌─────────────────────┐         │   │
│  │  │ ✓ خاتم دبلة كلاسيك  │  │   خاتم سوليتير     │         │   │
│  │  │ كود: RING-021       │  │   كود: RING-022     │         │   │
│  │  │ ⚖️ 4.5 جم          │  │   ⚖️ 3.2 جم         │         │   │
│  │  │ 💎 21              │  │   💎 21             │         │   │
│  │  │ 📂 خواتم           │  │   📂 خواتم          │  ◄─────┼  │
│  │  └─────────────────────┘  └─────────────────────┘    Tap │   │
│  │                                                              │   │
│  │  User taps: خاتم دبلة كلاسيك ──────────────────────────────│   │
│  └────────────────────────────────────────────────────────────┘   │
└──────────────────────────────┬──────────────────────────────────────┘
                               │ Navigate Push
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   PRODUCT DETAILS PAGE                               │
│                (product_details_page.dart)                           │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  🔙 Back    خاتم دبلة كلاسيك                   🛒 Cart      │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ╔══════════════════════════════════════════════════════════════╗  │
│  ║  PRODUCT INFORMATION                                         ║  │
│  ╚══════════════════════════════════════════════════════════════╝  │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  🖼️ [Product Image Placeholder]                             │   │
│  │  خاتم دبلة كلاسيك                                           │   │
│  │  كود: RING-021  |  متاح ✓                                  │   │
│  │  فئة: خواتم | دبلة زفاف كلاسيكية بتصميم أنيق                │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ╔══════════════════════════════════════════════════════════════╗  │
│  ║  CUSTOMIZATION OPTIONS                                       ║  │
│  ╚══════════════════════════════════════════════════════════════╝  │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  النوع:  [ذهب✓] [فضة] [لازوردي]                          │   │
│  └────────────────────────────────────────────────────────────┘   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  العيار: [18] [21✓] [24]  ▼ More                          │   │
│  └────────────────────────────────────────────────────────────┘   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  المقاس: [ 18 ▼ ]                                          │   │
│  └────────────────────────────────────────────────────────────┘   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  الوزن:  [ 5.5    ] جرام                                   │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ╔══════════════════════════════════════════════════════════════╗  │
│  ║  PRICING FORMULA                                             ║  │
│  ╚══════════════════════════════════════════════════════════════╝  │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  ┌────────────┐   ┌────────────┐   ┌────────────┐         │   │
│  │  │  سعر الذهب  │   │   21 ⓘ    │   │   21       │         │   │
│  │  │            │   │            │   │            │         │   │
│  │  │  2500      │   │  (ثابت)    │   │  (العيار)   │         │   │
│  │  └────────────┘   └────────────┘   └────────────┘         │   │
│  │                                                              │   │
│  │  Formula: (2500 × 5.5 × 21) ÷ 21                           │   │
│  │  أجرة المصنعية: 13,750.00 جنيه                             │   │
│  └────────────────────────────────────────────────────────────┘   │
│                      Auto-calculates on change ▲                    │
│                                                                      │
│  ╔══════════════════════════════════════════════════════════════╗  │
│  ║  DISCOUNT SECTION                                            ║  │
│  ╚══════════════════════════════════════════════════════════════╝  │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  نوع الخصم: ( ) بدون  (•) نسبة%  ( ) ثابت  ( ) كود       │   │
│  └────────────────────────────────────────────────────────────┘   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  Quick Presets: [5%] [10%✓] [15%] [20%] [25%] [30%]       │   │
│  │  Custom: [ 10 ] %                                           │   │
│  └────────────────────────────────────────────────────────────┘   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  OR Enter Code: [ GOLD10 ] → ✓ تم التطبيق: خصم 10%        │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ╔══════════════════════════════════════════════════════════════╗  │
│  ║  PRICE SUMMARY                                               ║  │
│  ╚══════════════════════════════════════════════════════════════╝  │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  أجرة المصنعية:          13,750.00 جنيه                    │   │
│  │  - الخصم (10%):           -1,375.00 جنيه                   │   │
│  │  ═══════════════════════════════════════════════════════     │   │
│  │  الإجمالي بعد الخصم:      12,375.00 جنيه                   │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │       🛒 [  إضافة للسلة  ] ← User clicks                   │   │
│  └────────────────────────────────────────────────────────────┘   │
└──────────────────────────────┬──────────────────────────────────────┘
                               │ Pop with data
                               │ {quantity: 1, price: 12375.0}
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│          BACK TO PROGRESSIVE DIALOG (Auto-closes)                    │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  _selectProduct receives result:                            │   │
│  │  {quantity: 1, price: 12375.0}                              │   │
│  │                                                              │   │
│  │  Calls: widget.onAddItem(product, 1)                        │   │
│  │  Then:  Navigator.pop() ─── Closes dialog                  │   │
│  └────────────────────────────────────────────────────────────┘   │
└──────────────────────────────┬──────────────────────────────────────┘
                               │ Return to
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    BACK TO GOLD SALES PAGE                           │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │  ✓ Product Added Successfully!                              │   │
│  │  ────────────────────────────────────────                   │   │
│  │  Sales List Updated:                                         │   │
│  │  1. خاتم دبلة كلاسيك - 12,375.00 جنيه                      │   │
│  │                                                              │   │
│  │  Total: 12,375.00 جنيه                                      │   │
│  └────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## Flow Summary Table

| Step | Screen | User Action | Navigation | Data Passed |
|------|--------|-------------|------------|-------------|
| 1 | HomePage | Click "مبيعات الذهب" | Push → GoldSalePage | None |
| 2 | GoldSalePage | Click "إضافة قطعة ذهب" | Show Dialog | availableProducts |
| 3 | Dialog Stage 0 | Search & select category | setState | selectedCategory |
| 4 | Dialog Stage 1 | Select type | setState | selectedType |
| 5 | Dialog Stage 2 | Filter & click "عرض النتائج" | setState | filters applied |
| 6 | Dialog Stage 3 | Tap product | Push → ProductDetails | GoldProduct |
| 7 | ProductDetails | Fill details | Auto-calculate | pricing data |
| 8 | ProductDetails | Apply discount (optional) | Recalculate | discount applied |
| 9 | ProductDetails | Click "إضافة للسلة" | Pop ← {quantity, price} | Map<String, dynamic> |
| 10 | Dialog | Receive result | Pop ← Dialog closes | Product added |
| 11 | GoldSalePage | View updated list | Show SnackBar | Product in cart |

## State Transitions

```
IDLE
  ↓ (User: إضافة قطعة ذهب)
DIALOG_STAGE_0_CATEGORY
  ↓ (User: Select category)
DIALOG_STAGE_1_TYPE
  ↓ (User: Select type)
DIALOG_STAGE_2_SPECIFICATIONS
  ↓ (User: عرض النتائج)
DIALOG_STAGE_3_RESULTS
  ↓ (User: Tap product)
PRODUCT_DETAILS_PAGE
  ↓ (User: Fill details)
CALCULATING_PRICE
  ↓ (User: Apply discount?)
CALCULATING_DISCOUNT
  ↓ (User: إضافة للسلة)
ADDING_TO_CART
  ↓ (Success)
BACK_TO_SALES ✓
```

## Exception Handling Points

| Location | Exception Type | Handling |
|----------|----------------|----------|
| Dialog navigation | Navigation exception | Try-catch, mounted check |
| Product selection | Null product | Null check before navigation |
| Details page load | Missing data | Display placeholder, disable actions |
| Price calculation | Invalid input | Show error, disable button |
| Discount code | Invalid code | Error message, keep old value |
| Add to cart | General exception | Catch, show SnackBar, log error |
| Navigation pop | Context disposed | Mounted check before pop |

## Responsive Breakpoints

| Screen Size | Category | Layout Adjustments |
|-------------|----------|-------------------|
| < 600px | Mobile | 2 columns, compact padding |
| 600-900px | Tablet | 3 columns, medium padding |
| > 900px | Desktop | 4 columns, generous padding |

Applied to:
- Category grid in Stage 0
- Product results grid in Stage 3
- Form sections in ProductDetailsPage

## Mock Data Integration

| Category | Arabic | Count | Example Codes |
|----------|--------|-------|---------------|
| Rings | خواتم | 8 | RING-021, RING-022, RING-999 |
| Chains | سلاسل | 6 | CHAIN-021, CHAIN-999 |
| Bracelets | أساور | 7 | BRAC-021 |
| Earrings | أقراط | 4 | EARR-021 |
| Wedding Bands | دبل | 4 | WEDD-021 |
| Sets | أطقم | 3 | SET-021 |
| Brooches | توك | 2 | BROO-021 |
| Anklets | غوايش | 2 | ANKL-021 |
| **Total** | | **48** | |

## Discount Codes Available

| Code | Type | Value | Arabic Description |
|------|------|-------|-------------------|
| GOLD10 | Percentage | 10% | خصم 10% على الذهب |
| GOLD20 | Percentage | 20% | خصم 20% على الذهب |
| SAVE100 | Fixed | 100 EGP | خصم 100 جنيه |
| SAVE200 | Fixed | 200 EGP | خصم 200 جنيه |
| VIP | Percentage | 25% | خصم كبار العملاء |

## Pricing Formula Breakdown

```
Given:
  - Gold Price (GP): User input in EGP
  - Weight (W): User input in grams
  - Karat (K): Selected karat (18, 21, 24)
  - Fixed Divisor: 21 (standard calculation base)

Calculate:
  Making Charge = (GP × W × K) ÷ 21

Example:
  GP = 2500 EGP/gram
  W = 5.5 grams
  K = 21 karat
  
  Making Charge = (2500 × 5.5 × 21) ÷ 21
                = 288,750 ÷ 21
                = 13,750 EGP

Apply Discount:
  If 10% discount:
    Discount Amount = 13,750 × 0.10 = 1,375 EGP
    Final Total = 13,750 - 1,375 = 12,375 EGP
```

## User Feedback Mechanisms

| Action | Feedback Type | Message | Color |
|--------|---------------|---------|-------|
| Product selected | Visual highlight | Golden border + glow | Gold |
| Filters applied | Stage transition | Shows results count | Neutral |
| Add to cart clicked | SnackBar | "تمت إضافة ... بنجاح" | Green |
| Error occurred | SnackBar | "خطأ في الإضافة: ..." | Red |
| Field invalid | Error text | Below input field | Red |
| Discount applied | Success text | "تم التطبيق: ..." | Green |
| Discount invalid | Error text | "كود خصم غير صحيح" | Red |

---

**Complete Flow Time:** ~30-60 seconds (from click to cart)
**User Interactions:** 7-10 taps/inputs
**Navigation Depth:** 3 levels max
**Data Validation Points:** 5 (inputs)
**Exception Handlers:** 7 locations
