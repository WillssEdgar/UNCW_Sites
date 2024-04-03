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
            "The building includes multi-disciplinary, hands-on laboratories equipped with the latest technologies; dynamically re-configurable research and educational spaces; student “sandboxes” to facilitate team-based collaborative learning; and a real-time financial trading room.",
        image: "assets/images/congdon-hall.jpeg"),
    const Site(
        name: "Sartarelli Hall",
        description:
            "Formerly known as Osprey Hall, Sartarelli Hall was recently renovated with new environmentally friendly lighting and technologial advances and is home to multiple univesrity departments.",
        image: "assets/images/sartarelli.jpeg"),
    const Site(
        name: "Randall Library",
        description:
            "Randall Library is named in honor of Dr. William Madison Randall, third president of Wilmington College. It has seating for approximately 1,000 persons and nearly two million items in various formats.",
        image: "assets/images/randall.jpeg"),
    const Site(
        name: "Fisher University Union",
        description:
            "One of the Campus Life facilities that offers a variety of resources, spaces and services to meet the needs of the campus community, including several university departments, campus dining locations, and community services such as the passport office and U.S. Postal Service.",
        image: "assets/images/fisher.jpeg"),
    const Site(
        name: "Trask Coliseum",
        description:
            "Trask Coliseum is named for Raiford G. Trask, benefactor and former Trustee of Wilmington College. It serves as home floor for men's and women's basketball teams.",
        image: "assets/images/trask.jpeg"),
    const Site(
        name: "Kenan Auditorium",
        description:
            "Kenan Auditorium is named in honor of Mrs. Sarah Graham Kenan, Wilmington philanthropist and benefactor of Wilmington College. It is the largest performing arts venue on campus.",
        image: "assets/images/kenan.webp")
  ];
}
