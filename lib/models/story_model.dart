class Story {
  final String companyName;
  final String headline;
  final String fullStory;
  final String image;

  final String? vision;
  final String? mission;
  final String? founders;

  Story({
    required this.companyName,
    required this.headline,
    required this.fullStory,
    required this.image,
    this.vision,
    this.mission,
    this.founders,
  });
}
