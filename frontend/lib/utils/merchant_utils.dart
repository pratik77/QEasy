import 'package:covidpass/enums/store_category.dart';

class MerchantUtils {
  static String getImageForMerchant(StoreCategory category) {
    switch (category) {
      case StoreCategory.GROCERIES:
        return "assets/vectors/ic_grocery.svg";
      case StoreCategory.MEDICINES:
        return "assets/vectors/ic_medicine.svg";
      case StoreCategory.MEAT:
        return "assets/vectors/ic_restaurant.svg";
      default:
        return null;
    }
  }
}
