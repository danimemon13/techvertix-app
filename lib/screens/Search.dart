import 'package:flutter/material.dart';

class Search extends  SearchDelegate{


  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
          query = "";
          }
      ),
    ];
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        }
    );
    throw UnimplementedError();
  }
  String SelectedResult;
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(SelectedResult),
      ),
    );
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  final List<String> contact;
  Search(this.contact);
  List<String> recentList = ["text3", "text4"];
  @override
  Widget buildSuggestions(BuildContext context) {
      List<String> suggestion = [];
      query.isEmpty
      ? suggestion = recentList
      : suggestion.addAll(contact.where((element) => element.contains(query),
      ));
      return ListView.builder(
        itemCount: suggestion.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text(
              suggestion[index]
            ),
            onTap: (){
              SelectedResult = suggestion[index];
              showResults(context);
            },
          );
        },
      );
    // TODO: implement buildSuggestions     TODO: implement buildSuggestions
    throw UnimplementedError();
  }
  
}