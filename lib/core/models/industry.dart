import 'industry_inventory_item.dart';
import 'industry_type.dart';
import 'good.dart';

class Industry {
  final IndustryType type;

  double size;

  /// Number of days of inputs this specific
  /// industry tries to keep in stock.
  double inputDaysTarget;

  /// Whether the player owns this industry.
  bool playerOwned;

  /// Cash reserves owned by the industry.
  double cash;

  /// Accounting for the most recent update.
  double lastRevenue;

  double lastExpenses;

  double lastProfit;

  /// Lifetime accounting.
  double lifetimeRevenue;

  double lifetimeExpenses;

  double get lifetimeProfit =>
      lifetimeRevenue -
      lifetimeExpenses;

  final List<IndustryInventoryItem>
      inventory;

  Industry({
    required this.type,
    required this.size,
    required this.inputDaysTarget,
    this.playerOwned = false,
    required this.cash,
    this.lastRevenue = 0,
    this.lastExpenses = 0,
    this.lastProfit = 0,
    this.lifetimeRevenue = 0,
    this.lifetimeExpenses = 0,
    required this.inventory,
  });

  double get storageCapacity {
    return type.storagePerSize * size;
  }

  double get currentStorage {
    return inventory.fold(
      0,
      (total, item) =>
          total + item.quantity,
    );
  }

  double get availableStorage {
    return storageCapacity -
        currentStorage;
  }

  IndustryInventoryItem?
      inventoryItemFor(
    Good good,
  ) {
    for (final item in inventory) {
      if (item.good == good) {
        return item;
      }
    }

    return null;
  }

  double quantityOf(
    Good good,
  ) {
    return inventoryItemFor(good)
            ?.quantity ??
        0;
  }

  void addInventory({
    required Good good,
    required double quantity,
  }) {
    final item =
        inventoryItemFor(good);

    if (item == null) {
      inventory.add(
        IndustryInventoryItem(
          good: good,
          quantity: quantity,
        ),
      );
      return;
    }

    item.quantity += quantity;
  }

  void removeInventory({
    required Good good,
    required double quantity,
  }) {
    final item =
        inventoryItemFor(good);

    if (item == null) {
      return;
    }

    item.quantity -= quantity;

    if (item.quantity <= 0) {
      inventory.remove(item);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.id,
      'size': size,
      'inputDaysTarget':
          inputDaysTarget,
      'playerOwned':
          playerOwned,
      'cash': cash,
      'lastRevenue': lastRevenue,
      'lastExpenses': lastExpenses,
      'lastProfit': lastProfit,
      'lifetimeRevenue':
          lifetimeRevenue,
      'lifetimeExpenses':
          lifetimeExpenses,
      'inventory': inventory
          .map(
            (item) => item.toJson(),
          )
          .toList(),
    };
  }

  factory Industry.fromJson({
    required Map<String, dynamic>
        json,
    required IndustryType Function(
      String id,
    )
    industryTypeForId,
    required Good Function(
      String id,
    )
    goodForId,
  }) {
    return Industry(
      type: industryTypeForId(
        json['type'] as String,
      ),
      size:
          (json['size'] as num)
              .toDouble(),
      inputDaysTarget:
          (json['inputDaysTarget']
                  as num)
              .toDouble(),
      playerOwned:
          json['playerOwned']
                  as bool? ??
              false,
      cash:
          (json['cash'] as num?)
                  ?.toDouble() ??
              1000,
      lastRevenue:
          (json['lastRevenue']
                      as num?)
                  ?.toDouble() ??
              0,
      lastExpenses:
          (json['lastExpenses']
                      as num?)
                  ?.toDouble() ??
              0,
      lastProfit:
          (json['lastProfit']
                      as num?)
                  ?.toDouble() ??
              0,
      lifetimeRevenue:
          (json['lifetimeRevenue']
                      as num?)
                  ?.toDouble() ??
              0,
      lifetimeExpenses:
          (json['lifetimeExpenses']
                      as num?)
                  ?.toDouble() ??
              0,
      inventory:
          (json['inventory']
                  as List)
              .map(
                (itemJson) =>
                    IndustryInventoryItem(
                  good: goodForId(
                    itemJson['good']
                        as String,
                  ),
                  quantity:
                      (itemJson[
                                  'quantity']
                              as num)
                          .toDouble(),
                ),
              )
              .toList(),
    );
  }
}