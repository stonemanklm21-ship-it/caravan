import '../models/world.dart';
import 'labour_service.dart';
import 'pricing_service.dart';

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

          if (purchased > 0) {
            final cost = PricingService.transactionCost(city: city, market: market, quantity: purchased.floor(),);

            expenses += cost;
            industry.cash -= cost;
          }

          market.quantity -= purchased;

          industry.addInventory( good: input.key, quantity: purchased,);}

        double efficiency = labourEfficiency;

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
        for (final input in industry.type.inputsPerSize.entries) {
          industry.removeInventory(
            good: input.key,
            quantity: input.value * industry.size * days * efficiency,);}

        // Produce outputs.
        for (final output in industry.type.outputsPerSize.entries) {
          industry.addInventory(good: output.key, quantity: output.value * industry.size * days * efficiency,);}

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