import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teyake/pages/side_bar.dart';
import 'package:get/get.dart';
import 'package:teyake/colors.dart';
import 'package:teyake/pages/comment.dart';
import 'package:teyake/pages/question_model.dart';
import 'package:teyake/pages/repo.dart';
import 'package:teyake/pages/save.dart';

class Display extends StatefulWidget {
  const Display({Key? key}) : super(key: key);

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  final _db = FirebaseFirestore.instance;
  final controller = Get.put(Repo());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> retrievedData = SaveData.retrieveUserData();
  bool _isLiked = false;
  List<TextEditingController> _commentControllers = [];
  final _formKey = GlobalKey<FormState>();

  Set<int> expandedQuestions = <int>{};
  late Future<List<QuestionModel>> _questionsFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool showComments = false;
  bool isKeyboardVisible = false;
  int selectedQuestionIndex = -1;
  bool isDarkMode = false;

  // Load the theme preference from SharedPreferences
  _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode =
          prefs.getBool('isDarkMode') ?? false; // Default to false if not set
    });
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  Future<void> _refreshDataquestion() async {
    setState(() {});

    _questionsFuture = controller.getAllquestion();
  }

  @override
  void initState() {
    super.initState();
    _loadThemePreference();

    _commentControllers = List.generate(
      100,
      (index) => TextEditingController(),
    );
    _questionsFuture = controller.getAllquestion();

    // Subscribe to keyboard visibility changes
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDarkMode ? Colors.black : Colors.grey,
      appBar: AppBar(
        title: Text(
          "Entries",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 26.0), // Adjust the font size as needed
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.transparent,
        centerTitle: true, // Set this to true for center alignment
        actions: [
          IconButton(
            icon: Icon(
              Icons.replay,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              _refreshDataquestion();
            },
          ),
        ],
        leading: IconButton(
          color: isDarkMode ? Colors.white : Colors.black,
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open the sidebar using the GlobalKey
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                await _refreshData();
              },
              child: FutureBuilder<List<QuestionModel>>(
                future: _questionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mainColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data available"));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.only(
                            bottom: isKeyboardVisible
                                ? MediaQuery.of(context).viewInsets.bottom
                                : 0,
                          ),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: isDarkMode ? Colors.grey : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            _toggleLikeStatus(
                                              snapshot.data![index].id,
                                              snapshot.data![index].like,
                                            );
                                            int item = int.parse(
                                                snapshot.data![index].like);
                                            if (_isLiked == false &&
                                                item >= 0) {
                                              item++;
                                            } else if (item > 0 &&
                                                _isLiked == true) {
                                              item--;
                                            }
                                            String value = item.toString();
                                            setState(() {
                                              snapshot.data![index].like =
                                                  value;
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              const Icon(
                                                Icons.thumb_up_alt,
                                                color: Colors.black38,
                                                size: 35.0,
                                              ),
                                              Positioned(
                                                bottom: 5,
                                                right: 12,
                                                top: 9,
                                                child: Text(
                                                  snapshot.data![index].like,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (snapshot.data![index].userid ==
                                          retrievedData["User-ID"])
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.cancel_outlined),
                                            onPressed: () {
                                              _showConfirmationDialogquestiom(
                                                  context,
                                                  snapshot.data![index].id);
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    snapshot.data![index].question,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                    ),
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 5),
                                  FutureBuilder<List<CommentModel>>(
                                    future: controller.getcomment(
                                        snapshot.data![index].questionid),
                                    builder: (context, commentSnapshot) {
                                      if (commentSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.mainColor,
                                          ),
                                        );
                                      } else if (commentSnapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            commentSnapshot.error.toString(),
                                          ),
                                        );
                                      } else if (!commentSnapshot.hasData ||
                                          commentSnapshot.data!.isEmpty) {
                                        const SizedBox(
                                          height: 10,
                                        );
                                        return const Center(
                                          child: Text("No comments"),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            if (commentSnapshot.data != null &&
                                                commentSnapshot
                                                    .data!.isNotEmpty &&
                                                expandedQuestions
                                                    .contains(index))
                                              SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      17.0),
                                                  child: Column(
                                                    children: List.generate(
                                                      commentSnapshot
                                                          .data!.length,
                                                      (commentIndex) {
                                                        return Column(
                                                          children: [
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child: Card(
                                                                elevation: 0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          1.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween, // Added this line
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              '${commentSnapshot.data![commentIndex].name}: ${commentSnapshot.data![commentIndex].comment}',
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black54,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          if (commentSnapshot.data![commentIndex].userid ==
                                                                              retrievedData["User-ID"])
                                                                            IconButton(
                                                                              icon: const Icon(Icons.cancel_outlined),
                                                                              onPressed: () {
                                                                                _showConfirmationDialog(context, commentSnapshot.data![commentIndex].id);
                                                                              },
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            if (commentIndex <
                                                                commentSnapshot
                                                                        .data!
                                                                        .length -
                                                                    1)
                                                              const Divider(
                                                                color:
                                                                    Colors.grey,
                                                                height: 0.1,
                                                              ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (commentSnapshot.data != null &&
                                                commentSnapshot
                                                    .data!.isNotEmpty)
                                              if (!expandedQuestions
                                                  .contains(index))
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: IconButton(
                                                    icon: const Icon(Icons
                                                        .keyboard_double_arrow_down_rounded),
                                                    iconSize: 35,
                                                    onPressed: () {
                                                      setState(() {
                                                        expandedQuestions
                                                            .add(index);
                                                      });
                                                    },
                                                  ),
                                                ),
                                            if (expandedQuestions
                                                .contains(index))
                                              Align(
                                                alignment: Alignment.center,
                                                child: IconButton(
                                                  icon: const Icon(Icons
                                                      .keyboard_double_arrow_up_sharp),
                                                  iconSize: 35,
                                                  onPressed: () {
                                                    setState(() {
                                                      expandedQuestions
                                                          .remove(index);
                                                    });
                                                  },
                                                ),
                                              ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildcommentField(index),
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _addItemToDatabase(
                                            context,
                                            snapshot.data![index].questionid,
                                            _commentControllers[index].text,
                                            index,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white70,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          fixedSize: const Size(
                                            90,
                                            30,
                                          ),
                                        ),
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleLikeStatus(String id, String like) async {
    int item = int.parse(like);
    if (_isLiked == false && item >= 0) {
      item++;
    } else if (item > 0 && _isLiked == true) {
      item--;
    }
    String value = item.toString();

    final Map<String, dynamic> itemData = {'Like': value};
    await _db.collection("questions").doc(id).update(itemData);

    setState(() {
      _isLiked = !_isLiked;
    });
  }

  Future<void> _addItemToDatabase(BuildContext context, String questionid,
      String comment, int index) async {
    if (comment.isEmpty) {
      const snackBar = SnackBar(
        content: Text(
          'Fill out Comment section, try again.',
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        await _db.collection("comment").add({
          'Comment': comment,
          'Question-ID': questionid,
          'Name': retrievedData["Name"],
          'User-ID': retrievedData["User-ID"],
        });
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to Add Store. Please try again.',
        );
      }

      Get.snackbar(
        'Comment Added',
        'Your Comment has been Added successfully',
      );

      _commentControllers[index].clear();
      FocusScope.of(context).unfocus();
      Get.back();
    }
  }

  Future<void> deletecomment(BuildContext context, String id) async {
    controller.delete(id);
    _refreshIndicatorKey.currentState?.show();
  }

  Future<void> _showConfirmationDialog(BuildContext context, String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this comment'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog and pass false
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Close the dialog and pass true
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        deletecomment(context, id);
      }
    });
  }

  Future<void> delete(BuildContext context, String id) async {
    controller.deleteEntry(id);
    _refreshDataquestion();
  }

  Future<void> _showConfirmationDialogquestiom(
      BuildContext context, String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this entry'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog and pass false
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Close the dialog and pass true
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        delete(context, id);
      }
    });
  }

  Widget _buildcommentField(int index) {
    return SizedBox(
      width: 230,
      height: 40,
      child: TextFormField(
        controller: _commentControllers[index],
        style: const TextStyle(fontSize: 12.0, color: Colors.black),
        decoration: InputDecoration(
          labelText: 'Comment',
          hintText: 'Enter your Comment',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.mainColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                const BorderSide(color: AppColors.mainColor, width: 2.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          prefixIcon: const Icon(Icons.comment, color: AppColors.mainColor),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter your Name';
          }
          return null;
        },
      ),
    );
  }
}
