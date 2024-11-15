import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/revisionView.dart';
import '../services/quiz_generator.dart';

class QuizScreen extends StatefulWidget {
  final String pdfBytesJson;

  const QuizScreen({super.key, required this.pdfBytesJson});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<String> questions = [];
  List<String> responses = [];
  bool isLoading = true;
  List<TextEditingController> answerControllers = [];
  List<List<String>> resultMessage = []; // Variable para almacenar el resultado

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    QuizGenerator quizGenerator = QuizGenerator();
    List<String> generatedQuestions =
        await quizGenerator.generateQuiz(widget.pdfBytesJson);
    setState(() {
      questions = generatedQuestions;
      answerControllers =
          List.generate(questions.length, (index) => TextEditingController());
      responses =
          List.filled(questions.length, ''); // Inicializa con respuestas vacías
      isLoading = false;
    });
  }

  // Aquí evaluamos las respuestas y mostramos el resultado
 Future<void> _evaluateQuiz() async {
    QuizGenerator quizGenerator = QuizGenerator();
    List<List<String>> result = await quizGenerator.evaluar(questions, responses);

    setState(() {
      resultMessage = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuestionario')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                questions[index],
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: answerControllers[index],
                                decoration: const InputDecoration(
                                  labelText: 'Tu respuesta',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  String answer = answerControllers[index].text;
                                  setState(() {
                                    responses[index] = answer;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Respuesta confirmada para la pregunta ${index + 1}')),
                                  );
                                },
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Primero, evaluar el cuestionario antes de navegar
                      _evaluateQuiz().then((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RevisionView(revisionData: resultMessage),
                          ),
                        );
                      });
                    },
                    child: Text('Revisar respuestas'),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    for (var controller in answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
