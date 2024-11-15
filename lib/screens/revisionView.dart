import 'package:flutter/material.dart';

class RevisionView extends StatelessWidget {
  final List<List<String>>
      revisionData; // Recibimos los datos en una lista de listas.

  const RevisionView({Key? key, required this.revisionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Desestructuramos los datos de la evaluación
    List<String> preguntas = revisionData[0];
    List<String> respuestas = revisionData[1];
    List<String> respuestasCorrectas =revisionData[2] ;
    List<String> sonRespuestasCorrectas =revisionData[3] ;
    List<String> calificacion = revisionData[4];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Revisión de Cuestionario'),
        backgroundColor: Colors.blueAccent, // Un color de fondo atractivo
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la sección de calificación
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Resumen de Evaluación',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),

              // Mostrar el número de respuestas correctas y la calificación final
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Respuestas Correctas: ${calificacion[0]}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[800],
                      ),
                    ),
                    Text(
                      'Calificación Final: ${calificacion[1]}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ),

              // Espacio entre el resumen y las preguntas
              SizedBox(height: 20),

              // Iterar sobre las preguntas y respuestas
              ListView.builder(
                shrinkWrap:
                    true, // Para que el ListView ocupe solo el espacio necesario
                physics:
                    NeverScrollableScrollPhysics(), // Deshabilitamos el desplazamiento
                itemCount: preguntas.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pregunta ${index + 1}:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            preguntas[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tu Respuesta:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange[700],
                            ),
                          ),
                          Text(
                            respuestas[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Respuesta Correcta:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[700],
                            ),
                          ),
                          Text(
                            respuestasCorrectas[
                                index], // Aquí mostramos la respuesta correcta
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                          SizedBox(height: 8),
                          // Mostrar si la respuesta fue correcta o no
                          Text(
                            (sonRespuestasCorrectas[index]=="1")
                                ? '¡Correcta!'
                                : 'Incorrecta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: (respuestas[index] ==
                                      respuestasCorrectas[index])
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
