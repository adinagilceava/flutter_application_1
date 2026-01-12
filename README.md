🌸 **BloomStudio** - **Aplicație Mobilă cu Integrare Stripe**

Acest proiect reprezintă o soluție completă de e-commerce pentru o florărie, formată dintr-o aplicație mobilă (Flutter) și un server de plăți (Node.js).

**Structura Proiectului**
Aplicația Flutter: Interfața utilizatorului, catalogul de produse și fluxul de checkout.
Serverul Stripe (Node.js): Gestionează crearea PaymentIntent și securizarea tranzacțiilor.
Codul pentru partea de Node.js se găsește aici: https://github.com/adinagilceava/bloom-studio-server.git

**Instrucțiuni de Configurare**
1. Configurarea Serverului (Backend)
-Serverul trebuie să ruleze pentru ca plățile să funcționeze.
-Navighează în folderul serverului: cd stripe_server.
-Instalează bibliotecile necesare: npm install.
-Creează un fișier .env în acest folder și adaugă cheia ta secretă:

**Plaintext**
STRIPE_SECRET_KEY=sk_test_... (cheia ta de aici)

Pornește serverul: node server.js (sau index.js).
Notă: Serverul va rula la adresa http://localhost:3000.

2. Configurarea Aplicației (Frontend)
Deschide proiectul Flutter în VS Code.

Rulează flutter pub get pentru a descărca pachetele.
**Important**: În codul Flutter, asigură-te că adresa IP a serverului este corectă.

-Dacă rulezi pe Android Emulator, folosește: http://10.0.2.2:3000/create-payment-intent
-Dacă rulezi pe iOS Simulator sau Web, folosește: http://localhost:3000/create-payment-intent.

Adaugă cheia publică Stripe în main.dart:

Dart: Stripe.publishableKey = "pk_test_... (cheia ta publica)";
Pornește aplicația: flutter run.


**Cerințe Tehnice**
Node.js instalat pe sistem.
Flutter SDK (versiunea stabilă).
Un cont Stripe (pentru cheile de test).

**Note Suplimentare**
Fișierul .env și folderul node_modules sunt ignorate de Git pentru securitate și performanță.
Pentru ca plățile să fie procesate, serverul trebuie să fie activ înainte de a apăsa butonul "Plătește" în aplicație.
