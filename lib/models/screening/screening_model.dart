class Question {
  final String id;
  final String question;
  final Map<String, int> options;

  Question({
    required this.id,
    required this.question,
    required this.options,
  });

  @override 
  String toString(){
    return 'Question(id: $id, question: $question, options: $options';
  }
}