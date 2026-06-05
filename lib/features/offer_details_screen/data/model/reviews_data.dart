class ReviewModel {
  final String name;
  final String date;
  final String review;
  final int rating;

  ReviewModel({
    required this.name,
    required this.date,
    required this.review,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      name: json['name'],
      date: json['date'],
      review: json['review'],
      rating: json['rating'],
    );
  }
}