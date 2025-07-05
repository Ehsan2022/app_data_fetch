import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   TextEditingController bookname = TextEditingController();
   TextEditingController authorname = TextEditingController();
   TextEditingController publishyear = TextEditingController();
   bool flag = true;
   List<dynamic> books=[];
   final String apiUrl = 'https://681cd33bf74de1d219adee2a.mockapi.io/books';

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  // Add books to API
  Future<void> addBook() async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': bookname.text,
      'author': authorname.text,
      'year': publishyear.text,
    }),
  );

  if (response.statusCode == 201) {
    bookname.clear();
    authorname.clear();
    publishyear.clear();
    await fetchBooks(); 
  }
}

  // Fetch books from API
  Future<void> fetchBooks() async {
    final response = await http.get(Uri.parse(apiUrl));
    setState(() {
           books = json.decode(response.body);
    });
  }
  Future<void> deleteBook(String id) async {
  final String deleteUrl = '$apiUrl/$id';
  final response = await http.delete(Uri.parse(deleteUrl));

  if (response.statusCode == 200) {
    await fetchBooks();
  }
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Library API",
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 3),
          ),
          backgroundColor: const Color.fromARGB(255, 12, 54, 79),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Add New Book",
                style: TextStyle(color:  Color.fromARGB(255, 12, 54, 79), fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bookname,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Book Name",
                  hintText: "Enter Book Name",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: authorname,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Author Name",
                  hintText: "Enter Author Name",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: publishyear,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Publish Year",
                  hintText: "Enter Book Publish Year",
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: (){
                    addBook();
                  },
                label:Text(
                  "Add Book", style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:  const Color.fromARGB(255, 12, 54, 79),
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 4,
                  shadowColor:  const Color.fromARGB(255, 12, 54, 79),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color:  Color.fromARGB(255, 12, 54, 79),
                thickness: 5,
              ),
              const Text("Book List", style: TextStyle(color: Color.fromARGB(255, 12, 54, 79),fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: books.isEmpty
                    ? const Center(child: Text("No books available.",style: TextStyle(color:  Color.fromARGB(255, 12, 54, 79)),))
                    : ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                            child: Container(
                              decoration: BoxDecoration(
                                color:  const Color.fromARGB(255, 12, 54, 79),
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: ListTile(   
                                      leading: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Text('${index + 1}',style: TextStyle(color:  const Color.fromARGB(255, 12, 54, 79)),),
                                            ),
                                      title:Text(book['name'], style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                                      subtitle:Text("Author: ${book['author']} | Year: ${book['year']}", style: const TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
                                      trailing:GestureDetector(
                                                 onTap: () async {
                                                    await deleteBook(book['id']);
                                                  },
                                                  child: Icon(Icons.delete,color:Colors.white ,size: 28,),
                                                ),
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
