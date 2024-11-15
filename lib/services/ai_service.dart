import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {

  Future<String> generateQuestions(String texto) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Eres un asistente útil para generar cuestionarios a partir de un texto.'
            },
            {
              'role': 'user',
              'content': '''
             recibe este texto y devuelveme un cuestionario de 1 preguntas. 
             aqui te dejo el formato que tiene que tener el cuestionario:
             ¿Cuál es la capital de Francia?
             ¿En qué año se fundó la Organización de las Naciones Unidas?.
            en la respuesta que me vas a dar , solamente tiene que estar el cuestionario
              $texto
            '''
            }
          ],
          'max_tokens': 100,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Error en la generación de preguntas: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
      throw Exception('Error al comunicarse con la API de OpenAI: $e');
    }
  }

  Future<String> evaluateResponses(String text) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'Eres un asistente útil.'},
            {
              'role': 'user',
              'content': '''
              responde solamente con "correcta" o "incorrecta" a esta pregunta con su respuesta
              si tampoco lo sabes entonces devuelve incorrecta , si mi respuesta es vacia tambien devuelve incorrecta:$text
            '''
            }
          ],
          'max_tokens': 50,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Error en la evaluación de respuestas: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
      throw Exception('Error al comunicarse con la API de OpenAI: $e');
    }
  }

  Future<String> evaluateResponseYCorregir(String text) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'Eres un asistente útil.'},
            {
              'role': 'user',
              'content': '''
              devuelveme la respuesta correcta de esta pregunta:$text
            '''
            }
          ],
          'max_tokens': 50,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Error en la evaluación de respuestas: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
      throw Exception('Error al comunicarse con la API de OpenAI: $e');
    }
  }
}
