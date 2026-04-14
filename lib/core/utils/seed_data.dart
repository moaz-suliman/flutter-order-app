import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedProducts() async {
  final db = FirebaseFirestore.instance;
  
  final products = [
    // Burgers
    {
      'name': 'Double Cheeseburger',
      'description': 'Classic beef burger',
      'price': 8.99,
      'category': 'Burgers',
      'imageUrl': 'https://i.ibb.co/L32R9bg/double-cheese-burger.jpg',
    },
    {
      'name': 'Crispy Chicken Burger',
      'description': 'Crispy fried chicken',
      'price': 7.99,
      'category': 'Burgers',
      'imageUrl': 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=400',
    },
    {
      'name': 'BBQ Bacon Burger',
      'description': 'Smoky BBQ with bacon',
      'price': 10.99,
      'category': 'Burgers',
      'imageUrl': 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=400',
    },
    // Pizza
    {
      'name': 'Pepperoni Feast',
      'description': 'Extra spicy sausage',
      'price': 12.50,
      'category': 'Pizza',
      'imageUrl': 'https://i.ibb.co/Fb8R22Rt/pizza.jpg',
    },
    {
      'name': 'Margherita Pizza',
      'description': 'Classic tomato and cheese',
      'price': 10.99,
      'category': 'Pizza',
      'imageUrl': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
    },
    {
      'name': 'BBQ Chicken Pizza',
      'description': 'Grilled chicken with BBQ sauce',
      'price': 13.99,
      'category': 'Pizza',
      'imageUrl': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400',
    },
    // Pasta
    {
      'name': 'Creamy Carbonara',
      'description': 'Italian style pasta',
      'price': 14.00,
      'category': 'Pasta',
      'imageUrl': 'https://i.ibb.co/cK6wgMbm/Creamy-Carbonara.jpg',
    },
    {
      'name': 'Penne Arrabiata',
      'description': 'Spicy tomato sauce pasta',
      'price': 11.99,
      'category': 'Pasta',
      'imageUrl': 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=400',
    },
    // Healthy
    {
      'name': 'Salmon Poke Bowl',
      'description': 'Healthy fresh greens',
      'price': 11.20,
      'category': 'Healthy',
      'imageUrl': 'https://i.ibb.co/PsnCtCmv/Salmon-Poke-Bowl.jpg',
    },
    {
      'name': 'Caesar Salad',
      'description': 'Fresh romaine lettuce',
      'price': 8.50,
      'category': 'Healthy',
      'imageUrl': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
    },
    // Desserts
    {
      'name': 'Sweet Donuts',
      'description': 'Assorted glazed box',
      'price': 6.50,
      'category': 'Desserts',
      'imageUrl': 'https://i.ibb.co/RGfq9b8L/Sweet-Donuts.jpg',
    },
    {
      'name': 'Chocolate Cake',
      'description': 'Rich dark chocolate',
      'price': 7.99,
      'category': 'Desserts',
      'imageUrl': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
    },
    // Drinks
    {
      'name': 'Fresh Orange Juice',
      'description': '100% natural juice',
      'price': 4.99,
      'category': 'Drinks',
      'imageUrl': 'https://i.ibb.co/3YrxBLc5/Fresh-Orange-Juice.jpg',
    },
    {
      'name': 'Strawberry Smoothie',
      'description': 'Fresh strawberry blend',
      'price': 5.99,
      'category': 'Drinks',
      'imageUrl': 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=400',
    },
    {
      'name': 'Lemonade',
      'description': 'Fresh squeezed lemon',
      'price': 3.99,
      'category': 'Drinks',
      'imageUrl': 'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=400',
    },
  ];

  for (final product in products) {
    await db.collection('products').add(product);
  }
}