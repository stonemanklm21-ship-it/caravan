import '../models/world.dart';
import 'labour_service.dart';
import 'pricing_service.dart';
import 'trade_analytics.dart';

class IndustryService {
  static const double wagePerWorkerPerDay = 1;

  static void advanceTime({
    required World world,
    required double hours,
  }) {
    final days = hours / 24;

    for (final city in world.cities) {
      final labourEfficiency =
          LabourService.cityEfficiency(city: city);

      for (final industry in city.industries) {
        double revenue = 0;
        double expenses = 0;

        // Buy inputs up to target stock.
        for (final input in industry.type.inputsPerSize.entries) {
          final market = city.marketForGood(input.key);

          final targetStock = input.value * industry.size * industry.inputDaysTarget;

          final currentStock = industry.quantityOf(input.key);

          final shortfall = targetStock - currentStock;

          if (shortfall <= 0) {continue;}

          final purchased = shortfall > market.quantity ? market.quantity : shortfall;

final unmetDemand =
    shortfall - purchased;

if (unmetDemand > 0) {
  TradeAnalytics.recordUnmetDemand(    input.key,    unmetDemand,  );}

          if (purchased > 0) {
            final cost = PricingService.transactionCost(city: city, market: market, quantity: purchased.floor(),);

            expenses += cost;
            industry.cash -= cost;
          }

          market.quantity -= purchased;

          industry.addInventory( good: input.key, quantity: purchased,);}

        double efficiency = labourEfficiency;

for (final input
    in industry.type.inputsPerSize.entries) {
  final desiredConsumption =
      input.value *
      industry.size *
      days;

  TradeAnalytics
      .recordDesiredConsumption(
    input.key,
    desiredConsumption,
  );
}
        // Check stored inputs.
        for (final input in industry.type.inputsPerSize.entries) {
          final required = input.value * industry.size * days;

          if (required <= 0) {
            continue;
          }

          final stored = industry.quantityOf(input.key);

          final availability = stored / required;

          if (availability < efficiency) {efficiency = availability;}}

        efficiency = efficiency.clamp(0.0, 1.0);

        // Consume inputs.
// Consume inputs.
for (final input    in industry.type.inputsPerSize.entries) {

  final quantityConsumed = input.value * industry.size *  days *  efficiency;

  industry.removeInventory(    good: input.key,    quantity: quantityConsumed,  );

  TradeAnalytics.recordConsumed(    input.key,    quantityConsumed,  );
}

        // Produce outputs.
// Produce outputs.
for (final output    in industry.type.outputsPerSize.entries) {

  final quantityProduced =      output.value *      industry.size *      days *      efficiency;

  industry.addInventory(    good: output.key,    quantity: quantityProduced,  );

  TradeAnalytics.recordProduced(    output.key,    quantityProduced,  );
}
        // Sell all outputs to market.
        for (final output in industry.type.outputsPerSize.keys) {
          final quantity = industry.quantityOf(output);

          if (quantity <= 0) {continue;}

          final market = city.marketForGood(output);

          final saleRevenue =
              PricingService.transactionRevenue(
            city: city,
            market: market,
            quantity: quantity.floor(),
          );

          revenue += saleRevenue;
          industry.cash += saleRevenue;

          market.quantity += quantity;

          industry.removeInventory(good: output, quantity: quantity,);}

        // Operating costs.
        final operatingCost =
            industry.type.operatingCostPerSizePerDay *
            industry.size *
            days;

        expenses += operatingCost;
        industry.cash -= operatingCost;

        // Labour costs.
        final labourCost =
            industry.type.workersPerSize *
            industry.size *
            wagePerWorkerPerDay *
            days;

        expenses += labourCost;
        industry.cash -= labourCost;

        industry.lastRevenue = revenue;
        industry.lastExpenses = expenses;
        industry.lastProfit = revenue - expenses;

        industry.lifetimeRevenue += revenue;
        industry.lifetimeExpenses += expenses;
      }
    }
  }
}