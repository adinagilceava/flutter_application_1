import 'package:flutter/material.dart';
// aspect vizual, fara el aplicația nu ar ști ce este acela widget (oferă butoane, texte, imagini etc.)
import 'package:flutter_stripe/flutter_stripe.dart'; // integrare serviciu de plată
import 'dart:convert'; // pentru conversia datelor JSON, 
import 'package:http/http.dart' as http;
// aplicația flutter comunică mai întâi cu serverul node.js, nu poate comunica direct cu Stripe


/* 
  & APLICAȚIA BLOOMSTUDIO
  & Proiect Flutter - bloom Studio - Magazin de flori și plante
  & Student: Constantina-Adina Gîlceavă
  & Data: Ianuarie 2026
*/
void main() async {
  // async deoarece inițializarea Stripe poate dura ceva timp
  WidgetsFlutterBinding.ensureInitialized(); 
  // se asigură că toate widget-urile sunt inițializate înainte de a continua
  
  // CONFIGURARE STRIPE - se înlocuiește cu cheia publicabilă, aici se realizează legătura dintre aplicație și Stripe
  Stripe.publishableKey = "pk_test_51SmtcWCwAWMlKmTqeYFzHW4hxBb2mg45xkar7tLrGP8CbKNjf3uz4kZx8asPgYvuPuIMYPzdwRfE3zRiI75O0mdi00UciAtZV8";
  
  runApp(const BloomStudioApp()); // se lansează interfața grafică a aplicației
}

// --- APLICAȚIA PRINCIPALĂ ---
class BloomStudioApp extends StatelessWidget {
  const BloomStudioApp({super.key});
  @override // se ignoră setările implicite și se suprascrie
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'BloomStudio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 240, 245), // Culoarea aleasă principala
          primary: const Color.fromARGB(255, 246, 102, 150),
        ),
        useMaterial3: true,
        //sistem de design modern
        fontFamily: 'Monserat', // Oferă un aspect mai elegant pentru un studio floral
      ),
      home: const OnboardingScreen(),
      //prima pagina cand se deschide aplicatia
    );
  }
}

// --- MODELE DE DATE ---
// se stochează informațiile, dar nu se desenează nimic deocamdată
class OnboardingContent {
  String image, title, description;
  OnboardingContent({required this.image, required this.title, required this.description});
}// nu se poate crea pagina pana cand nu se dau toate aceste informatii (prin this facem asta)

class Product {
  final String id, name, image, description,category;
  final double price;
  int quantity;
  bool isFavorite;

  Product({
    required this.id, 
    required this.name, 
    required this.image, 
    required this.price, 
    required this.description,
    required this.category,
    this.quantity = 1, 
    this.isFavorite = false
  });
}

// --- DATE GLOBALE ---
List<OnboardingContent> contents = [
  OnboardingContent(
    title: 'Natura, la tine acasă',
    image: 'assets/images/lalea.jpg',
    description: "Descoperă colecții florale unice, create special pentru a aduce prospețime și culoare în fiecare colț al căminului tău.",
  ),
  OnboardingContent(
    title: 'Expertiza noastră, pasiunea ta',
    image: 'assets/images/roses.jpg',
    description: "Nu ești singur în îngrijirea plantelor. Primești sfaturi de la experți și mementouri inteligente.",
  ),
  OnboardingContent(
    title: 'Emoții livrate instant',
    image: 'assets/images/trandafir.jpg',
    description: "Fiecare buchet este o poveste. Îl pregătim cu dragoste și îl livrăm cu grijă, direct la ușa ta.",
  ),
];

List<Product> allProducts = [
  Product(id: "1", name: "Buchet lalele roșii", category: "Buchete", image: "assets/images/lalea.jpg", price: 60.0, description: "Un buchet vibrant de lalele proaspete, simbol al dragostei perfecte."),
  Product(id: "2", name: "Buchet trandafiri", category: "Buchete", image: "assets/images/trandafir.jpg", price: 65.0, description: "Trandafiri premium selecționați manual pentru momente de neuitat."),
  Product(id: "3", name: "Cactus Desert", category: "De interior", image: "assets/images/roses.jpg", price: 50.0, description: "O plantă rezistentă și elegantă, ideală pentru decorul biroului tău."),
  Product(id: "4", name: "Buchet lalele mix", category: "Buchete", image: "assets/images/image4.jpg", price: 85.0, description: "Un amestec vesel de culori primăvăratice într-un singur aranjament."),
  Product(id: "5", name: "Buchete trandafiri", category: "Buchete", image: "assets/images/image5.jpg", price: 120.0, description: "Aranjament luxos de trandafiri în culori pastelate."),
  Product(id: "6", name: "Buchet flori sălbatice", category:"Buchete" , image:"assets/images/image6.jpg" , price :65.0 , description:"Adu prospețimea naturii în casa ta cu acest buchet rustic."),
  Product(id: "7", name: "Buchet mireasă", category: "Buchete", image: "assets/images/image7.jpg", price: 35.0, description: "Eleganță pură creată special pentru cea mai frumoasă zi din viața ta."),
  Product(id: "8", name: "Buchet mix cu frunze", category: "Buchete", image: "assets/images/image8.jpg", price: 150.0, description: "Un design floral contemporan ce îmbină flori exotice cu texturi bogate."),
  Product(id: "9", name: "Cactus Verde", category: "Suculente", image: "assets/images/cactus.jpg", price: 40.0, description: "Un cactus verde vibrant, perfect pentru a adăuga un strop de natură spațiului tău."),
  Product(id: "10", name: "Hortensie Albastră", category: "Flori", image: "assets/images/hortensie.jpeg", price: 55.0, description: "O hortensie albastră delicată, ideală pentru a înfrumuseța orice încăpere."),
  Product(id: "11", name: "Aechmea Fasciata", category: "De interior", image: "assets/images/aechmea.jpg", price: 70.0, description: "O plantă tropicală cu frunze spectaculoase și flori vibrante."),
  Product(id: "12", name: "Bonsai Miniatural", category: "De interior", image: "assets/images/bonsai.jpeg", price: 90.0, description: "Un bonsai elegant, simbol al răbdării și al armoniei."),
  Product(id: "13", name: "Yucca Elegans", category: "De interior", image: "assets/images/yucca.jpeg", price: 80.0, description: "O yucca impunătoare, perfectă pentru a adăuga un aer exotic casei tale."),
  
 ];
 

List<Product> cartItems = [];

// --- ECRAN ONBOARDING ---
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: contents.length,
              onPageChanged: (int index) => setState(() => currentIndex = index),
              itemBuilder: (_, i) => Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Image.asset(contents[i].image, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Text(contents[i].title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2F4F4F))),
                        const SizedBox(height: 15),
                        Text(contents[i].description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(contents.length, (index) => buildDot(index)),
          ),
          Container(
            height: 55,
            margin: const EdgeInsets.all(40),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                } else {
                  controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: const Color.fromARGB(255, 255, 251, 251),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              child: Text(
                currentIndex == contents.length - 1 ? "ÎNCEPE" : "CONTINUĂ"),
                
            ),
          )
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? Theme.of(context).colorScheme.primary : const Color.fromARGB(255, 255, 240, 245),
      ),
    );
  }
}

// --- ECRAN LOGIN ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_florist_outlined, size: 80, color: Color.fromARGB(255, 246, 102, 150)), // Un logo simplu
            const SizedBox(height: 20),
            const Text("Autentificare", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 15),
            TextField(obscureText: true, decoration: InputDecoration(labelText: "Parolă", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation())),
                child: const Text("CONECTARE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Sau continuă cu:"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                socialIconButton(Icons.g_mobiledata, Colors.red, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()))),
                const SizedBox(width: 20),
                socialIconButton(Icons.apple, Colors.black, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()))),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget socialIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(15)),
        child: Icon(icon, color: color, size: 35),
      ),
    );
  }
}


// --- NAVIGARE PRINCIPALĂ ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // index-ul paginii curente
  final List<Widget> _pages = [ // lista paginilor disponibile
    const HomeScreen(), // se apelează constructorul claselor definite mai jos
    const CatalogScreen(),
    const FavoriteScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,     // pagina curentă
        onTap: (index) => setState(() => _selectedIndex = index), // redesenează ecranul cu noua pagină selectată
        type: BottomNavigationBarType.fixed, //definire aspect vizual 
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [ // definire elemente meniu cu icons și etichete
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Acasă"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Produse"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Coș"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }
}
// --- ECRAN DETALII PRODUS ---
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int tempQuantity = 1;
  final TextEditingController _promoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagine Hero
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(widget.product.image), fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                      IconButton(
                        icon: Icon(widget.product.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 30),
                        onPressed: () => setState(() => widget.product.isFavorite = !widget.product.isFavorite),
                      ),
                    ],
                  ),
                  Text("${widget.product.price} RON", style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Descriere", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(widget.product.description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 30),
                  
                  // Cantitate
                  const Text("Selectează Cantitatea", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => setState(() { if(tempQuantity > 1) tempQuantity--; })),
                      Text("$tempQuantity", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() { tempQuantity++; })),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  // Cod Promotie
                  TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      labelText: "Cod Reducere (ex: BLOOM10)",
                      suffixIcon: TextButton(onPressed: () {}, child: const Text("Aplică")),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          widget.product.quantity = tempQuantity;
                          if (!cartItems.contains(widget.product)) cartItems.add(widget.product);
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Adăugat în coș cu succes!")));
                      },
                      child: const Text("ADAUGĂ ÎN COȘ", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// --- ECRAN HOME ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  final List<String> categorii = ["Toate", "De interior", "Buchete", "Suculente", "Flori"];
final List<Product> populare = allProducts.sublist(0, 3); // Primele 3
final List<Product> noutati = allProducts.sublist(3, 6);  // Următoarele 3
final List<Product> speciale = allProducts.sublist(6, 8); // Ultimele 2 
  @override
  Widget build(BuildContext context) {
    // 1. Calculăm lista filtrată DOAR dacă nu suntem pe "Toate"
    List<Product> produseFiltrate = [];
    if (selectedCategoryIndex != 0) {
      produseFiltrate = allProducts
          .where((p) => p.category == categorii[selectedCategoryIndex])
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BloomStudioLogo(),
              _buildSearchBar(),
              _buildCategoryList(),

              // 2. LOGICĂ DE AFIȘARE:
              if (selectedCategoryIndex == 0) ...[
                // --- ACESTA ESTE ECRANUL DE "PRIMA DESCHIDERE" ---
                _buildProductSection("Populare la BloomStudio", allProducts.sublist(0, 3)),
                _buildProductSection("Cele mai vândute în Ianuarie", allProducts.sublist(3, 6)),
                _buildProductSection("Pentru Ziua Mamei", allProducts.sublist(6, 8)),
              ] else ...[
                // --- ACESTA ESTE ECRANUL DUPĂ FILTRARE ---
                _buildProductSection(
                  "Rezultate pentru ${categorii[selectedCategoryIndex]}", 
                  produseFiltrate
                ),
                
                // Mesaj dacă categoria e goală
                if (produseFiltrate.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Text(
                        "Momentan nu avem produse în această categorie.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
              ],
              
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET-URI EXTRASE PENTRU CURĂȚENIE ---

 // 1. Funcția pentru Bara de Căutare
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
        child: const TextField(
          decoration: InputDecoration(
            hintText: "Caută flori...", 
            border: InputBorder.none, 
            icon: Icon(Icons.search)
          ),
        ),
      ),
    );
  }
  


  // 2. Funcția pentru Lista de Categorii
  Widget _buildCategoryList() {
    return Column(
      children: [
        const SizedBox(height: 25),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categorii.length,
            padding: const EdgeInsets.only(left: 20),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                // Această linie permite schimbarea între "Toate" și categorii
                setState(() => selectedCategoryIndex = index);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: selectedCategoryIndex == index 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    categorii[index], 
                    style: TextStyle(
                      color: selectedCategoryIndex == index ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 3. Funcția Universală pentru Secțiuni de Produse (Șablon)
  Widget _buildProductSection(String title, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            padding: const EdgeInsets.only(left: 20),
            itemBuilder: (context, index) => buildProductCard(products[index]),
          ),
        ),
      ],
    );
  }

  // Cardul de produs individual
  Widget buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(product.image, height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text("${product.price} RON", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Vezi detalii...", style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// --- ECRAN CATALOG ---
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Avem nevoie de aceste variabile pentru a menține starea categoriilor și în această pagină
  int selectedCategoryIndex = 0;
  final List<String> categorii = ["Toate", "De interior", "Buchete", "Suculente", "Flori"];

//lista de filtrare produse
 List<Product> getFilteredProducts() {
    if (selectedCategoryIndex == 0) return allProducts;
    return allProducts.where((p) => p.category == categorii[selectedCategoryIndex]).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Apelare filtrarea
    final displayedProducts = getFilteredProducts();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Folosim Column pentru a pune elementele unul sub altul
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Titlu) - Consistență cu pagina Home
           const BloomStudioLogo(), // Apelează widget-ul creat mai sus

            // 2. Bara de Căutare (Funcție preluată de la Home)
            _buildSearchBar(),

            // 3. Meniul de Categorii (Funcție preluată de la Home)
            _buildCategoryList(),

            const SizedBox(height: 10),

            // 4. Lista de produse
            // Folosim Expanded pentru ca lista să ocupe tot spațiul rămas pe verticală
            Expanded(
              child: ListView.separated(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                itemCount: displayedProducts.length, // Folosește lista filtrată
                itemBuilder: (context, index) {
                  final product = displayedProducts[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(product.image, width: 80, height: 80, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const Text("BloomStudio Collection", style: TextStyle(color: Colors.grey, fontSize: 14)),
                              Text("${product.price} RON", 
                                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (!cartItems.any((item) => item.id == product.id)) {cartItems.add(product);}
                              else {product.quantity++;}
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${product.name} adăugat!")));
                          },
                          icon: Icon(Icons.add_shopping_cart, color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row( // Folosim Row pentru a alinia butonul și search bar-ul
      children: [
        // BUTONUL DE SORTARE
        Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: PopupMenuButton<String>(
            icon: Icon(Icons.swap_vert, color: Theme.of(context).colorScheme.primary),
            tooltip: "Sortează după preț",
            onSelected: (String criteria) {
              // Aici apelăm logica de sortare pe lista allProducts sau lista filtrată
              setState(() {
                if (criteria == 'asc') {
                  allProducts.sort((a, b) => a.price.compareTo(b.price));
                } else if (criteria == 'desc') {
                  allProducts.sort((a, b) => b.price.compareTo(a.price));
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'asc', child: Text("Preț: Mic la Mare")),
              const PopupMenuItem(value: 'desc', child: Text("Preț: Mare la Mic")),
            ],
          ),
        ),
        
        // BARA DE CĂUTARE PROPRIU-ZISĂ
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[100], 
              borderRadius: BorderRadius.circular(15),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Caută flori...", 
                border: InputBorder.none, 
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  // 2. Funcția pentru Lista de Categorii
  Widget _buildCategoryList() {
    return Column(
      children: [
        const SizedBox(height: 25),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categorii.length,
            padding: const EdgeInsets.only(left: 20),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => setState(() => selectedCategoryIndex = index),
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: selectedCategoryIndex == index ? Theme.of(context).colorScheme.primary : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(categorii[index], 
                    style: TextStyle(color: selectedCategoryIndex == index ? Colors.white : Colors.black54)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// --- ECRAN FAVORITE ---
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    List<Product> favoriteProducts = allProducts.where((product) => product.isFavorite).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column( // Folosim Column pentru a pune Logo-ul deasupra listei
        children: [
          // 1. Aici apelăm widget-ul tău personalizat
          const BloomStudioLogo(),

          // 2. Conținutul paginii
          Expanded( // Expanded este necesar pentru ca lista să ocupe restul spațiului
            child: favoriteProducts.isEmpty
                ? const Center(
                    child: Text("Nu ai produse favorite încă la BloomStudio."),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect( // Adăugăm margini rotunjite la imagine
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(product.image, width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${product.price} RON", style: const TextStyle(color: Colors.green)),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => setState(() => product.isFavorite = false),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}
}
// --- ECRAN PROFIL ---

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 25),
              _buildStatsSection(context), // Secțiune nouă pentru interactivitate
              const SizedBox(height: 25),
              _buildRecentOrders(context), // Afișarea comenzilor cu succes
              const SizedBox(height: 25),
              _buildMenuSection(context),
              const SizedBox(height: 100), // Spațiu pentru bara plutitoare
            ],
          ),
        ),
      ),
    );
  }

  // 1. Header cu aspect mai modern
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person, size: 60, color: Colors.grey),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: const Icon(Icons.edit, size: 18, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text("Adina Constantina", 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F4F4F))),
        const Text("Client Premium BloomStudio", 
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // 2. Secțiune de Statistici (Puncte Loialitate, Vouchere)
  Widget _buildStatsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statCard("Comenzi", "12", Icons.local_mall_outlined, context),
          _statCard("Puncte", "450", Icons.star_outline, context),
          _statCard("Vouchere", "2", Icons.confirmation_number_outlined, context),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // 3. Vizualizare Comenzi Recente (Succes)
  Widget _buildRecentOrders(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ultima comandă plătită", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Comanda #8824", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Buchet Lalele + Trandafiri", style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ),
                Text("135 RON", 
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. Meniu Opțiuni
  Widget _buildMenuSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _menuTile(context, Icons.location_on_outlined, "Setări profil", () {}),
          _menuTile(context, Icons.notifications_none_rounded, "Istoric", () {}),
          _menuTile(context, Icons.help_outline, "Suport BloomStudio", () {}),
          const Divider(indent: 20, endIndent: 20),
          _menuTile(context, Icons.logout_rounded, "Deconectare", () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
          }, isLast: true, color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isLast = false, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
      shape: isLast ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))) : null,
    );
  }
}
// --- ECRAN COȘ ---
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Logo-ul apare acum indiferent dacă coșul e plin sau gol
            const BloomStudioLogo(),
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        "Coșul tău BloomStudio este gol",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(item.image, width: 50, height: 50, fit: BoxFit.cover),
                          ),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${(item.price * item.quantity).toStringAsFixed(2)} RON"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () => setState(() {
                                  if (item.quantity > 1) {item.quantity--;}
                                  else {cartItems.removeAt(index);}
                                }),
                              ),
                              Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: () => setState(() => item.quantity++),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Secțiunea de Total apare doar dacă există produse în coș
            if (cartItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 5)
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("TOTAL:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          "${total.toStringAsFixed(2)} RON",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ShippingScreen()),
                        ),
                        child: const Text("DATE DE LIVRARE", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- ECRAN LIVRARE ---
class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});
  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Date DE LIVRARE"), elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(decoration: const InputDecoration(labelText: "Nume și Prenume", border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextFormField(decoration: const InputDecoration(labelText: "Adresă de livrare", border: OutlineInputBorder()), maxLines: 2),
              const SizedBox(height: 15),
              TextFormField(decoration: const InputDecoration(labelText: "Telefon", border: OutlineInputBorder()), keyboardType: TextInputType.phone),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentSimulationScreen())),
                  child: const Text("PLĂTEȘTE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SERVICIU STRIPE ---
class StripeService {
  // PENTRU iOS SIMULATOR folosește localhost
  static const String backendUrl = 'http://localhost:3000';
  
  Future<Map<String, dynamic>> createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
    }
  }
}

// PaymentSimulationScreen - ECRAN SIMULARE PLATĂ
class PaymentSimulationScreen extends StatefulWidget {
  const PaymentSimulationScreen({super.key});
  @override
  State<PaymentSimulationScreen> createState() => _PaymentSimulationScreenState();
}

class _PaymentSimulationScreenState extends State<PaymentSimulationScreen> {
  final _stripeService = StripeService();
  bool isProcessing = false;

  Future<void> _makePayment() async {
    setState(() => isProcessing = true);
    
    try {
      // Calculează totalul din coș
      double total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
      String amountInBani = (total * 100).toInt().toString(); // Convertește în bani
      
      // 1. Creează Payment Intent pe backend
      final paymentIntentData = await _stripeService.createPaymentIntent(
        amount: amountInBani,
        currency: 'RON',
      );
      
      // 2. Inițializează Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'BloomStudio',
          style: ThemeMode.light,
        ),
      );
      
      // 3. Afișează Payment Sheet
      await Stripe.instance.presentPaymentSheet();
      
      // 4. Plată reușită
      setState(() => isProcessing = false);
      _showSuccessDialog();
      
    } on StripeException catch (e) {
      setState(() => isProcessing = false);
      _showErrorDialog('Eroare plată: ${e.error.localizedMessage}');
    } catch (e) {
      setState(() => isProcessing = false);
      _showErrorDialog('Eroare: $e');
    }
  }
// Afișează dialogul de succes
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          "Plată reușită la BloomStudio!\nComanda ta a fost înregistrată.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              cartItems.clear();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("ÎNAPOI LA STUDIO"),
          )
        ],
      ),
    );
  }
// Afișează dialogul de eroare
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('❌ Eroare'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
    // Construiește UI-ul ecranului de plată
  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizare Plată"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.payment, size: 100, color: Colors.green),
              const SizedBox(height: 30),
              const Text(
                'Total de Plată',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                '${total.toStringAsFixed(2)} RON',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isProcessing ? null : _makePayment,
                  icon: isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.payment),
                  label: Text(
                    isProcessing ? 'PROCESARE...' : 'PLĂTEȘTE CU STRIPE',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Plata este securizată de Stripe 🔒',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Widget  logo BloomStudio
class BloomStudioLogo extends StatelessWidget {
  const BloomStudioLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_florist, 
              color: Theme.of(context).colorScheme.primary, 
              size: 32,
            ),
            const SizedBox(width: 10),
            Text(
              "BloomStudio",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}