import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'books.dart';

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
   List<Book> books = [];


  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  // Add books to API
  Future<void> addBook() async {
    const String apiUrl = 'https://681cd33bf74de1d219adee2a.mockapi.io/books';

    http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': bookname.text,
        'author': authorname.text,
        'year': publishyear.text,
      }),
    );
    bookname.clear();
    authorname.clear();
    publishyear.clear();
    fetchBooks(); // Refresh list after adding
  }

  // Fetch books from API
  Future<void> fetchBooks() async {
    const String apiUrl = 'https://681cd33bf74de1d219adee2a.mockapi.io/books';

    final response = await http.get(Uri.parse(apiUrl));
    List<dynamic> data = jsonDecode(response.body);
    setState(() {
      books = data.map((json) => Book.fromJson(json)).toList();
    });
  }

  Future<void> updateBook(String id, String newName, String newAuthor, String newYear) async {
     final String apiUrl = 'https://681cd33bf74de1d219adee2a.mockapi.io/books/$id';

     await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': newName,
        'author': newAuthor,
        'year': newYear,
      }),
    );
      fetchBooks(); // Refresh data in the UI
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Working with API",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Add New Book",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: addBook,
                label:Text(
                  flag ?"Add Book":"Update",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 4,
                  shadowColor: Colors.blueGrey.shade700,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text("Book List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: books.isEmpty
                    ? const Center(child: Text("No books available."))
                    : ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Text('${index + 1}'),
                                    ),
                                    Column(
                                      children: [
                                        Text(book.name, style: const TextStyle(color: Colors.white),),
                                        Text("Author: ${book.author} | Year: ${book.year}", style: const TextStyle(color: Colors.white70),),
                                      ],
                                    ),
                                    Row(
                                    children: [
                                      GestureDetector(
                                          onTap: (){
                                            flag = false;
                                            var newName =bookname.text=book.name;
                                            var newAuthor =authorname.text=book.author;
                                            var newYear =publishyear.text=book.year;
                                            updateBook(book.id, newName, newAuthor, newYear);
                                          },
                                          child: Icon(Icons.edit,color:Colors.white ,size: 28,),
                                        ),
                                        SizedBox(width: 10),
                                      GestureDetector(
                                          onTap: (){
                                            final String deleteUrl = 'https://681cd33bf74de1d219adee2a.mockapi.io/books/${book.id}';
                                            http.delete(Uri.parse(deleteUrl));
                                            fetchBooks();
                                          },
                                          child: Icon(Icons.delete,color:Colors.white ,size: 28,),
                                        ),
                                    ],
                                  )
                                ],
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

// ListTile(
//                                 leading: 
//                                 title: Text(book.name, style: const TextStyle(color: Colors.white),),
//                                 subtitle: Text("Author: ${book.author} | Year: ${book.year}", style: const TextStyle(color: Colors.white70),),
//                                 trailing: 