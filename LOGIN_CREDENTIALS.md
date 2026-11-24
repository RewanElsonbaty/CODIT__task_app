# 🔐 بيانات تسجيل الدخول - Login Credentials

## المستخدمين حسب الميزة (Feature-Based Users)

**كل مستخدم له صلاحية الوصول لميزة واحدة فقط!**

---

### 👤 المستخدمين المتاحين:

| المستخدم | Username | Password | الصلاحية الوحيدة |
|---------|----------|----------|------------------|
| **بيع الذهب** | `gold_user` | `gold123` | 💰 Gold Sales POS فقط |
| **الفروع** | `branches_user` | `branches123` | 📊 Branches Monitoring فقط |
| **الموافقات** | `approvals_user` | `approvals123` | ✅ Approvals فقط |
| **الأقساط** | `installments_user` | `installments123` | 📝 Installments فقط |
| **المدير** | `admin` | `admin123` | 🔓 جميع الصلاحيات |

---

## 📝 طريقة الاستخدام

### 1️⃣ موظف بيع الذهب (Gold Sales):

```
Username: gold_user
Phone: 01012345678  (أي رقم)
Password: gold123
```

**الصلاحيات**:
- ✅ Gold Sales POS
- ❌ Approvals (ممنوع)
- ❌ Installments (ممنوع)
- ❌ Branches (ممنوع)

---

### 2️⃣ مراقب الفروع (Branches Monitor):

```
Username: branches_user
Phone: 01098765432  (أي رقم)
Password: branches123
```

**الصلاحيات**:
- ✅ Branches Monitoring
- ❌ Gold Sales (ممنوع)
- ❌ Approvals (ممنوع)
- ❌ Installments (ممنوع)

---

### 3️⃣ مسؤول الموافقات (Approvals Officer):

```
Username: approvals_user
Phone: 01123456789  (أي رقم)
Password: approvals123
```

**الصلاحيات**:
- ✅ Approvals Management
- ❌ Gold Sales (ممنوع)
- ❌ Branches (ممنوع)
- ❌ Installments (ممنوع)

---

### 4️⃣ مسؤول الأقساط (Installments Officer):

```
Username: installments_user
Phone: 01234567890  (أي رقم)
Password: installments123
```

**الصلاحيات**:
- ✅ Installments Tracking
- ❌ Gold Sales (ممنوع)
- ❌ Branches (ممنوع)
- ❌ Approvals (ممنوع)

---

### 5️⃣ المدير (Admin - Full Access):

```
Username: admin
Phone: 01111111111  (أي رقم)
Password: admin123
```

**الصلاحيات**:
- ✅ جميع الميزات

---

## 🎯 معلومات المستخدمين:

### 💰 Gold User:
- **ID**: `user_gold_001`
- **Full Name**: محمد أحمد - موظف مبيعات ذهب
- **Role**: `gold_sales_staff`
- **Permissions**: `['gold_sales', 'gold_pos']`

### 📊 Branches User:
- **ID**: `user_branches_002`
- **Full Name**: سارة علي - مراقب فروع
- **Role**: `branch_monitor`
- **Permissions**: `['branches', 'monitoring']`

### ✅ Approvals User:
- **ID**: `user_approvals_003`
- **Full Name**: خالد محمود - مسؤول موافقات
- **Role**: `approver`
- **Permissions**: `['approvals', 'approval_management']`

### 📝 Installments User:
- **ID**: `user_installments_004`
- **Full Name**: نور حسن - مسؤول أقساط
- **Role**: `installments_officer`
- **Permissions**: `['installments', 'payments']`

### 🔓 Admin:
- **ID**: `user_admin_005`
- **Full Name**: أحمد محمد - مدير النظام
- **Role**: `admin`
- **Permissions**: `['all']`

---

## 🔐 التحقق (Validation):

### Username:
- ✅ 3-50 حرف
- ✅ حروف، أرقام، نقطة، شرطة سفلية فقط
- ✅ Pattern: `^[a-zA-Z0-9._]+$`

### Phone:
- ✅ 10-15 رقم
- ✅ يمكن أن يبدأ بـ `+`
- ✅ Pattern: `^\+?\d{10,15}$`

### Password:
- ✅ 6-50 حرف
- ✅ حرف واحد على الأقل
- ✅ رقم واحد على الأقل

---

## 🎓 ملاحظات مهمة:

1. **كل user له ميزة واحدة فقط** ✅
2. **لو user حاول يدخل صفحة ممنوعة** → هيرجع للـ Home
3. **الـ Home Page تعرض الميزات المتاحة فقط** للـ user
4. **Username حساس** لحالة الأحرف
5. **رقم الهاتف** للتجربة فقط - أي رقم صحيح

---

## 🔧 للتطوير (Legacy Users):

المستخدمين القدامى لازالوا متاحين للاختبار:

| Username | Password | Permissions |
|----------|----------|-------------|
| `admin@codit.gold` | `Admin@123` | All |
| `manager@codit.gold` | `Manager@123` | Multiple |
| `cashier@codit.gold` | `Cashier@123` | Sales |

---

## 🎉 جاهز للاستخدام!

**التاريخ**: 23 نوفمبر 2026  
**الحالة**: ✅ Feature-Based Authentication Active  
**Users**: 4 Specialized + 1 Admin
