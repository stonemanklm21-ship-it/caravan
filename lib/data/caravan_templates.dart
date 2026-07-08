class CaravanTemplate {
  final String name;

  final int companions;

  final int donkeys;
  final int horses;
  final int ox;
  final int camels;

  final int smallCarts;
  final int carts;
  final int largeCarts;

  final double minGold;
  final double maxGold;

  final int weight;

  const CaravanTemplate({
    required this.name,
    required this.companions,
    required this.donkeys,
    required this.horses,
    required this.ox,
    required this.camels,
    required this.smallCarts,
    required this.carts,
    required this.largeCarts,
    required this.minGold,
    required this.maxGold,
    required this.weight,
  });
}

const peddler = CaravanTemplate(
  name: 'Peddler',
  companions: 1,
  donkeys: 1,
  horses: 0,
  ox: 0,
  camels: 0,
  smallCarts: 0,
  carts: 0,
  largeCarts: 0,
  minGold: 1000,
  maxGold: 2000,
  weight: 50,
);

const trader = CaravanTemplate(
  name: 'Trader',
  companions: 2,
  donkeys: 2,
  horses: 0,
  ox: 0,
  camels: 0,
  smallCarts: 1,
  carts: 0,
  largeCarts: 0,
  minGold: 2000,
  maxGold: 4000,
  weight: 30,
);

const merchant = CaravanTemplate(
  name: 'Merchant',
  companions: 3,
  donkeys: 0,
  horses: 2,
  ox: 0,
  camels: 0,
  smallCarts: 0,
  carts: 1,
  largeCarts: 0,
  minGold: 4000,
  maxGold: 8000,
  weight: 15,
);

const caravanCompany = CaravanTemplate(
  name: 'Caravan Company',
  companions: 5,
  donkeys: 0,
  horses: 4,
  ox: 2,
  camels: 0,
  smallCarts: 0,
  carts: 2,
  largeCarts: 1,
  minGold: 8000,
  maxGold: 15000,
  weight: 5,
);

const caravanTemplates = [
  peddler,
  trader,
  merchant,
  caravanCompany,
];