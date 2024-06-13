import 'package:eco_clean/pages/fournisseur/menu-f.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class ModuleEducatifsPage extends StatefulWidget {
  const ModuleEducatifsPage({super.key});

  @override
  _ModuleEducatifsPageState createState() => _ModuleEducatifsPageState();
}

class _ModuleEducatifsPageState extends State<ModuleEducatifsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'L\'Impact de la Pollution sur l\'Environnement',
    'Comment Trier Mes Déchets Correctement',
    'Réutiliser Mes Déchets : Idées Créatives',
    'Protéger les Océans : Pourquoi et Comment',
    'L\'Énergie Renouvelable et la Planète',
  ];
  List<String> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _filteredCategories = _categories;

    _searchController.addListener(() {
      setState(() {
        _filteredCategories = _categories
            .where((category) => category
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  void _navigateToArticles(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlesPage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // définir un style de bouton commun
    final ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
      backgroundColor:
          const Color.fromARGB(255, 211, 211, 182), // couleur de fond beige
      foregroundColor: Colors.black, // couleur du texte noir
      minimumSize: const Size(double.infinity, 45),
    );

    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 172, 145),
        toolbarHeight: 90.0,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Module Educatif',
            style: TextStyle(
              fontSize: 39.0,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: 36,
            color: Colors.black,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 238, 245, 213),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _searchController,
                cursorColor:
                    const Color.fromARGB(255, 32, 58, 33), //couleur du curseur
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 32, 58,
                          33), //couleur de la bordure lorsqu'elle est focalisée
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 32, 58,
                          33), //couleur de la bordure lorsqu'elle est activée mais pas focalisée
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: () => _navigateToArticles(
                            context, _filteredCategories[index]),
                        style: commonButtonStyle,
                        child: Text(
                          _filteredCategories[index],
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticlesPage extends StatelessWidget {
  final String category;

  const ArticlesPage({super.key, required this.category});

  List<Widget> get _articles {
    switch (category) {
      // Article 1
      case 'L\'Impact de la Pollution sur l\'Environnement':
        return [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text:
                      'L\'Humain : Comment la pollution affecte notre santé\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'La pollution de l\'air est l\'une des principales causes de maladies respiratoires et cardiovasculaires chez l\'homme. Les particules fines (PM2.5) et les oxydes d\'azote (NOx) sont particulièrement dangereux. Selon l\'Organisation Mondiale de la Santé (OMS), environ 7 millions de personnes meurent chaque année à cause de l\'exposition à la pollution de l\'air. Les enfants, les personnes âgées et les individus souffrant de maladies chroniques sont les plus vulnérables.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      'L\'Environnement : Les effets sur l\'air, l\'eau et le sol\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'La pollution affecte gravement notre environnement. Les émissions de gaz à effet de serre contribuent au réchauffement climatique, tandis que les polluants chimiques peuvent contaminer les sols et les cours d\'eau, affectant ainsi la flore et la faune. Par exemple, les pesticides utilisés dans l\'agriculture peuvent se retrouver dans les nappes phréatiques, empoisonnant les plantes et les animaux.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      'Les Animaux : Comment la faune souffre de la pollution\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les animaux sont fortement impactés par la pollution. Les déchets plastiques dans les océans tuent des millions d\'animaux marins chaque année. Les oiseaux peuvent ingérer des plastiques, confondant les déchets avec de la nourriture, ce qui peut provoquer une occlusion intestinale et la mort. Les habitats naturels sont également détruits par la pollution, menaçant de nombreuses espèces.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      'Les Solutions : Ce que nous pouvons faire pour réduire la pollution\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Pour réduire la pollution, nous pouvons adopter plusieurs comportements éco-responsables : utiliser les transports en commun, recycler nos déchets, et soutenir les énergies renouvelables. Par ailleurs, des politiques publiques strictes sont nécessaires pour réguler les émissions industrielles et promouvoir des pratiques agricoles durables.',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ];
      // Article 2
      case 'Comment Trier Mes Déchets Correctement':
        return [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text:
                      'Les Types de Déchets : Plastique, papier, verre et organique\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les déchets peuvent être classés en plusieurs catégories : plastique, papier, verre et organique. Chaque type de déchet nécessite un traitement spécifique pour être recyclé efficacement. Le plastique, par exemple, peut être recyclé en nouveaux produits plastiques, tandis que les déchets organiques peuvent être compostés pour produire du compost.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Les Bacs de Recyclage : Couleurs et signification\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les bacs de recyclage sont souvent codés par couleur pour faciliter le tri. Par exemple, les bacs bleus sont généralement utilisés pour le papier et le carton, les bacs verts pour le verre, et les bacs jaunes pour les plastiques et les métaux. Le tri correct de ces déchets permet d\'améliorer le taux de recyclage et de réduire la quantité de déchets envoyés aux décharges.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      'Les Déchets Dangereux : Comment gérer les piles, les médicaments, etc.\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les déchets dangereux, tels que les piles, les médicaments et les produits chimiques, ne doivent pas être jetés avec les ordures ménagères. Ils doivent être apportés dans des centres de collecte spécifiques pour être traités correctement. Une mauvaise gestion de ces déchets peut entraîner des risques pour la santé publique et l\'environnement.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      'Les Centres de Recyclage : Où apporter les objets volumineux\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les centres de recyclage acceptent les objets volumineux qui ne peuvent pas être pris en charge par le service de collecte des ordures ménagères. Ces centres sont équipés pour traiter les appareils électroménagers, les meubles et autres objets encombrants, en veillant à ce qu\'ils soient recyclés ou éliminés de manière écologique.',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ];
      // Article 3
      case 'Réutiliser Mes Déchets : Idées Créatives':
        return [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text:
                      'Les Déchets Ménagers : Projets de bricolage et d\'artisanat\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les déchets ménagers, tels que les boîtes de conserve, les bouteilles en plastique et les vieux vêtements, peuvent être réutilisés pour créer des projets de bricolage et d\'artisanat. Par exemple, vous pouvez transformer des boîtes de conserve en porte-crayons ou des bouteilles en plastique en jardinières. Ces projets sont non seulement amusants, mais ils permettent aussi de réduire la quantité de déchets envoyés aux décharges.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Les Meubles : Upcycling et relooking\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'L\'upcycling consiste à donner une nouvelle vie à des meubles anciens ou endommagés en les transformant en pièces uniques et stylées. Vous pouvez, par exemple, repeindre une vieille commode, ajouter de nouvelles poignées ou utiliser des palettes en bois pour créer une table basse. Ce processus permet de réduire les déchets et de créer des meubles personnalisés à moindre coût.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Les Déchets Verts : Compostage à domicile\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les déchets verts, tels que les restes de fruits et légumes, les feuilles mortes et les tontes de gazon, peuvent être compostés à domicile. Le compostage transforme ces déchets organiques en un engrais naturel riche en nutriments pour vos plantes. Vous pouvez utiliser un composteur de jardin ou un bac à compost pour commencer à composter chez vous.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Les Déchets Électroniques : Réparer et réutiliser\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les déchets électroniques, tels que les vieux téléphones, ordinateurs et autres appareils, peuvent souvent être réparés ou réutilisés au lieu d\'être jetés. Vous pouvez donner ces appareils à des associations qui les remettront en état, ou les utiliser pour créer de nouveaux gadgets. Cela permet de réduire la quantité de déchets électroniques et de promouvoir une économie circulaire.',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ];
      // Article 4
      case 'Protéger les Océans : Pourquoi et Comment':
        return [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'La Pollution Plastique : Un fléau pour les océans\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les océans sont gravement menacés par la pollution plastique. Chaque année, des millions de tonnes de plastique finissent dans les océans, tuant la faune marine et détruisant les habitats naturels. Les microplastiques, en particulier, sont ingérés par les animaux marins, entrant ainsi dans la chaîne alimentaire et affectant potentiellement la santé humaine.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Les Récifs Coralliens : Importance et protection\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les récifs coralliens sont des écosystèmes marins extrêmement importants, abritant une grande diversité d\'espèces. Ils sont cependant menacés par la pollution, le changement climatique et la surpêche. Protéger les récifs coralliens nécessite des efforts concertés pour réduire la pollution, limiter le réchauffement climatique et promouvoir des pratiques de pêche durable.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Les Zones Marines Protégées : Rôles et avantages\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les zones marines protégées (ZMP) sont des régions de l\'océan où les activités humaines sont réglementées pour préserver les écosystèmes marins. Les ZMP jouent un rôle crucial dans la conservation de la biodiversité marine, la protection des habitats critiques et la restauration des populations de poissons. Elles contribuent également à la résilience des océans face aux impacts du changement climatique.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      'Les Actions Individuelles : Ce que vous pouvez faire\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Chacun de nous peut contribuer à la protection des océans par des actions simples : réduire notre consommation de plastique, participer à des nettoyages de plages, soutenir des organisations de conservation marine et sensibiliser notre entourage à l\'importance de protéger les océans. Chaque geste compte pour préserver la santé et la beauté de nos océans.',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ];
      // Article 5
      case 'L\'Énergie Renouvelable et la Planète':
        return [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text:
                      'Les Types d\'Énergies Renouvelables : Solaire, éolienne, hydraulique\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les énergies renouvelables proviennent de sources naturelles qui sont constamment renouvelées. Les principaux types d\'énergies renouvelables sont l\'énergie solaire, l\'énergie éolienne et l\'énergie hydraulique. L\'énergie solaire utilise les panneaux solaires pour convertir la lumière du soleil en électricité, l\'énergie éolienne utilise des éoliennes pour générer de l\'électricité à partir du vent, et l\'énergie hydraulique utilise la force de l\'eau pour produire de l\'électricité.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      'Les Avantages des Énergies Renouvelables : Durabilité et impact environnemental\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Les énergies renouvelables offrent de nombreux avantages par rapport aux énergies fossiles. Elles sont durables, c\'est-à-dire qu\'elles ne s\'épuisent pas avec le temps, et elles ont un impact environnemental beaucoup plus faible. En utilisant des énergies renouvelables, nous pouvons réduire nos émissions de gaz à effet de serre, diminuer notre dépendance aux combustibles fossiles et protéger l\'environnement.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      'Les Défis des Énergies Renouvelables : Coûts et stockage\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Malgré leurs nombreux avantages, les énergies renouvelables présentent également des défis. Le coût initial des installations, comme les panneaux solaires et les éoliennes, peut être élevé. De plus, le stockage de l\'énergie produite est un problème, car les sources renouvelables comme le soleil et le vent ne sont pas toujours disponibles. Les avancées technologiques sont nécessaires pour rendre le stockage de l\'énergie plus efficace et abordable.\n\n',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      'Les Initiatives Mondiales : Projets et politiques en faveur des énergies renouvelables\n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 57, 100, 59),
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'De nombreux pays à travers le monde ont mis en place des projets et des politiques pour promouvoir les énergies renouvelables. Des initiatives telles que l\'Accord de Paris visent à réduire les émissions de gaz à effet de serre et à augmenter l\'utilisation des énergies renouvelables. Ces efforts sont essentiels pour lutter contre le changement climatique et protéger notre planète pour les générations futures.',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ];
      default:
        return [const Text('Aucun article disponible pour cette catégorie.')];
    }
  }

  Future<void> share(String category) async {
    await FlutterShare.share(
      title: 'Module Educatif',
      text: 'Découvrez notre article sur $category.',
      chooserTitle: 'Partager l\'article',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 172, 145),
        toolbarHeight: 90.0,
        title: Center(
          child: Column(
            children: [
              Text(
                category,
                style: const TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              GestureDetector(
                onTap: () => share(category),
                child: const Icon(Icons.share),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 238, 245, 213),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _articles,
          ),
        ),
      ),
    );
  }
}
