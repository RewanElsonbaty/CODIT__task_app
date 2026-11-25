# Quick Test Guide - Product Details Integration

## 🚀 Quick Start (5 Minutes)

### 1. Launch App
```powershell
cd e:\flutter_projects\CODIT-TASK
flutter run
```

Wait for app to launch (connected device or emulator required).

### 2. Navigate to Gold Sales
1. App opens → Home screen appears
2. Look for card: **"مبيعات الذهب"** (Gold Sales)
3. Tap the card

### 3. Open Add Product Dialog
1. On Gold Sales page, look for button: **"إضافة قطعة ذهب"**
2. Tap the button
3. Dialog opens with Stage 0 (categories)

### 4. Quick Happy Path Test

#### Stage 0: Select Category
- In search field, type: **"ر"** (Arabic letter)
- You should see: **خواتم** (Rings) highlighted
- Tap **خواتم** card

#### Stage 1: Select Type
- You'll see title: "اختر نوع خواتم"
- Tap **ذهب** (Gold) card

#### Stage 2: Filter Specifications
- Karat chips appear
- Tap **21** chip (should highlight golden)
- Weight slider shows (0-100 جم)
- Keep default range or adjust
- Tap button: **"عرض النتائج"**

#### Stage 3: View Products
- Grid of products appears (filtered)
- Look for product cards with:
  - Name, code, weight, karat
- **TAP ANY PRODUCT CARD** ← This is the new integration!

#### Product Details Page (NEW!)
You should now see a detailed page with:
1. ✅ Product name in top bar
2. ✅ Product information section
3. ✅ Type selector chips (ذهب selected)
4. ✅ Karat selector (21 selected)
5. ✅ Size dropdown
6. ✅ Weight input field
7. ✅ Pricing formula (3 containers)
8. ✅ Discount section
9. ✅ Price summary
10. ✅ Bottom "إضافة للسلة" button

#### Fill Required Fields
1. **المقاس (Size):** Tap dropdown → Select **18**
2. **الوزن (Weight):** Tap field → Enter **5.5**
3. **سعر الذهب (Gold Price):** In formula section → Enter **2500**

Watch the magic:
- Making charge auto-calculates: **13,750.00 جنيه**
- Price summary updates automatically

#### Apply Discount (Optional)
1. Under "الخصم", select: **"كود خصم"**
2. Enter code: **GOLD10**
3. Tap "تطبيق" (Apply)
4. ✅ Success message: "تم التطبيق: خصم 10%"
5. Price summary updates:
   - Discount: -1,375.00 جنيه
   - Total: 12,375.00 جنيه

#### Add to Cart
1. Bottom button should now be **ENABLED** (green)
2. Tap: **"إضافة للسلة"**
3. ✅ Success SnackBar appears
4. ✅ Page closes automatically
5. ✅ Dialog also closes
6. ✅ You're back on Gold Sales page
7. ✅ Product added to sales list

### Expected Result
✅ Product "خاتم دبلة كلاسيك" added with:
- Quantity: 1
- Price: 12,375.00 جنيه (after 10% discount)

---

## 🧪 Test Different Scenarios (10 Minutes)

### Scenario 1: No Discount
- Follow steps above, but don't apply discount
- Final price should be: 13,750.00 جنيه

### Scenario 2: Percentage Discount
- In discount section, select: "نسبة مئوية"
- Tap preset: **20%**
- Final price: 11,000.00 جنيه

### Scenario 3: Fixed Amount Discount
- Select: "مبلغ ثابت"
- Enter: **500**
- Final price: 13,250.00 جنيه

### Scenario 4: Different Karat
- Change karat to: **18**
- Same weight (5.5) and gold price (2500)
- Making charge: 11,785.71 جنيه
- Formula: (2500 × 5.5 × 18) ÷ 21

### Scenario 5: Different Category
- Start over with: **سلاسل** (Chains)
- Type: **ذهب**
- Karat: **21**
- Filter and select a chain
- Fill details and add

---

## 🔍 What to Look For

### ✅ Success Indicators
1. **Navigation Smooth**
   - No freezes or delays
   - Pages open and close cleanly

2. **Calculations Correct**
   - Making charge formula accurate
   - Discounts calculate properly
   - Totals update in real-time

3. **UI Responsive**
   - On mobile, tablet, desktop
   - Text readable, buttons tappable
   - No overflow errors

4. **Data Flow Working**
   - Product data passed correctly
   - Filters work as expected
   - Add to cart completes successfully

5. **User Feedback**
   - Success messages appear
   - Error messages clear (if validation fails)
   - Visual highlights on selections

### ❌ Error Indicators
1. **Navigation Fails**
   - App crashes
   - White screen
   - "Navigator" errors

2. **Calculations Wrong**
   - Making charge = 0 when inputs filled
   - Discount not applying
   - Negative totals

3. **UI Broken**
   - Text overflows
   - Buttons not responding
   - Layout messy

4. **Data Issues**
   - Product details missing
   - Filters don't work
   - Add to cart fails

5. **Missing Feedback**
   - No success message
   - Silent failures
   - No visual response to taps

---

## 🐛 Quick Troubleshooting

### Problem: Dialog doesn't open
**Solution:** Check if "إضافة قطعة ذهب" button is visible and tappable.

### Problem: No products in Stage 3
**Solution:** Filters might be too restrictive. Try:
- Select "الكل" for karat
- Expand weight range to full (0-100)

### Problem: Product details page doesn't open
**Solution:** Check console for errors:
```powershell
flutter logs
```

### Problem: Making charge stays 0
**Solution:** Ensure all three inputs filled:
- Gold price (in formula section)
- Weight (in weight field)
- Karat (selected with chips/dropdown)

### Problem: Add button disabled
**Solution:** Check required fields:
- Size selected? (dropdown not empty)
- Weight entered? (number > 0)
- Gold price entered? (number > 0)

### Problem: Discount code doesn't work
**Solution:** Verify exact code:
- Try: `GOLD10` (case-insensitive should work)
- Not: `gold10`, `GOLD 10`, `GOLD-10`
- Check in mock_gold_sales_api.dart if needed

---

## 📊 Expected Performance

| Metric | Target | Acceptable |
|--------|--------|------------|
| Dialog open time | < 500ms | < 1s |
| Details page open | < 500ms | < 1s |
| Calculation update | < 100ms | < 300ms |
| Add to cart | < 500ms | < 1s |
| Total flow time | 30-45s | < 60s |

---

## 📱 Test Devices

### Minimum Test Coverage
1. **Mobile**: Android/iOS phone (< 600px width)
2. **Tablet**: iPad/Android tablet (600-900px)
3. **Desktop**: Web/desktop (> 900px) - optional

### Quick Device Check
```powershell
# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device_id>
```

---

## 📋 5-Minute Verification Checklist

- [ ] App launches without errors
- [ ] Home screen displays correctly
- [ ] Navigate to Gold Sales works
- [ ] "إضافة قطعة ذهب" button clickable
- [ ] Dialog opens (Stage 0)
- [ ] Category search works (try "ر")
- [ ] Select خواتم → Stage 1 appears
- [ ] Select ذهب → Stage 2 appears
- [ ] Select karat 21 → chip highlights
- [ ] Click "عرض النتائج" → Stage 3 appears
- [ ] Products displayed in grid
- [ ] **TAP PRODUCT → Details page opens** ⭐
- [ ] **Product details page loads fully** ⭐
- [ ] **Fill size, weight, gold price** ⭐
- [ ] **Making charge calculates** ⭐
- [ ] **Apply discount code "GOLD10"** ⭐
- [ ] **Discount applied successfully** ⭐
- [ ] **Click "إضافة للسلة"** ⭐
- [ ] **Page closes, returns to sales** ⭐
- [ ] **Product added to cart** ⭐
- [ ] **Success message shows** ⭐

**If all checked: ✅ Integration Successful!**

---

## 🎯 Key Success Metric

**Can you complete this flow in under 60 seconds?**
1. Click "مبيعات الذهب"
2. Click "إضافة قطعة ذهب"
3. Type "ر" and select خواتم
4. Select ذهب
5. Select 21 karat
6. Click "عرض النتائج"
7. Tap first product
8. Enter: Size 18, Weight 5.5, Price 2500
9. Code: GOLD10
10. Click "إضافة للسلة"

**Result:** Product in cart with correct price (12,375 EGP)

If yes → **Perfect! Integration working as designed.** ✅

If no → Check troubleshooting section above or run:
```powershell
flutter clean
flutter pub get
flutter run
```

---

## 📞 Support

If issues persist:
1. Check TESTING_CHECKLIST.md for detailed tests
2. Review INTEGRATION_COMPLETE.md for technical details
3. See USER_FLOW_DIAGRAM.md for visual flow
4. Check console logs for errors

**Last Updated:** 2026-11-25
**Version:** 1.0.0
**Status:** ✅ Ready for Testing
