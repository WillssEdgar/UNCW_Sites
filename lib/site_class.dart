class Site {
  final String name;
  final String description;
  final String image;

  const Site(
      {required this.name, required this.description, required this.image});
}

class SiteData {
  final List<String> siteNames = [
    "Congdon Hall",
    "Sartarelli Hall",
    "Randall Library",
    "Fisher University Union",
    "Trask Coliseum",
    "Kenan Auditorium"
  ];

  final List<Site> sites = [
    const Site(
        name: "Congdon Hall",
        description:
            "Building for Congdon School of Supply Chain, Business Analytics, and Information Systems",
        image: "../asset/images/congdon.jpg"),
    const Site(
        name: "Sartarelli Hall",
        description: "Building for Mathematics",
        image: "assets/images/sartarelli.jpeg"),
    const Site(
        name: "Randall Library",
        description: "Student library with art galleries and study spaced",
        image: "assets/images/randall.jpeg"),
    const Site(
        name: "Fisher University Union",
        description:
            "Center for many Campus Life activies, offices, and resturants",
        image: "assets/images/fisher.jpeg"),
    const Site(
        name: "Trask Coliseum",
        description:
            "Serves as home floor for men's and women's basketball teams",
        image: "assets/images/trask.jpeg"),
    const Site(
        name: "Kenan Auditorium",
        description: "Largest performing arts venue on campus",
        image: "assets/images/kenan.webp")
  ];
}
