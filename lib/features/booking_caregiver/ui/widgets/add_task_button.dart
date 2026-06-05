import 'package:flutter/material.dart';

import '../../../../core/widgets/gradient_action_button.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientActionButton(
      text: "+ Add New Task",

      onTap: () {

        showDialog(
          context: context,

          builder: (context) {

            return Dialog(
              backgroundColor: Colors.transparent,

              child: Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(18),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    /// HEADER
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        const SizedBox(width: 24),

                        const Text(
                          "Add New Task",

                          style: TextStyle(
                            color:
                            Color(0xff2F80ED),
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context);
                          },

                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// TASK NAME
                    Align(
                      alignment:
                      Alignment.centerLeft,

                      child: Text(
                        "Task Name",

                        style: TextStyle(
                          color:
                          Colors.grey[700],
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      decoration: InputDecoration(
                        hintText:
                        "Enter task name",

                        hintStyle: TextStyle(
                          color:
                          Colors.grey[500],
                          fontSize: 13,
                        ),

                        contentPadding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),

                        enabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius
                              .circular(8),

                          borderSide:
                          const BorderSide(
                            color: Color(
                                0xffBFC7D7),
                          ),
                        ),

                        focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius
                              .circular(8),

                          borderSide:
                          const BorderSide(
                            color: Color(
                                0xff2F80ED),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// PHOTO
                    Align(
                      alignment:
                      Alignment.centerLeft,

                      child: Text(
                        "Photo of Receipt/Result",

                        style: TextStyle(
                          color:
                          Colors.grey[700],
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      width: double.infinity,

                      padding:
                      const EdgeInsets
                          .symmetric(
                        vertical: 12,
                      ),

                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius
                            .circular(8),

                        border: Border.all(
                          color: const Color(
                              0xffBFC7D7),
                        ),
                      ),

                      child: const Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                        children: [

                          Icon(
                            Icons
                                .camera_alt_outlined,
                            size: 16,
                            color: Color(
                                0xff2F80ED),
                          ),

                          SizedBox(width: 6),

                          Text(
                            "Add Photo/Video Proof",

                            style: TextStyle(
                              color: Color(
                                  0xff2F80ED),
                              fontSize: 12,
                              fontWeight:
                              FontWeight
                                  .w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// PRICE
                    Align(
                      alignment:
                      Alignment.centerLeft,

                      child: Text(
                        "Price",

                        style: TextStyle(
                          color:
                          Colors.grey[700],
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      decoration: InputDecoration(
                        hintText:
                        "Enter price",

                        hintStyle: TextStyle(
                          color:
                          Colors.grey[500],
                          fontSize: 13,
                        ),

                        contentPadding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),

                        enabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius
                              .circular(8),

                          borderSide:
                          const BorderSide(
                            color: Color(
                                0xffBFC7D7),
                          ),
                        ),

                        focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius
                              .circular(8),

                          borderSide:
                          const BorderSide(
                            color: Color(
                                0xff2F80ED),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// ADD BUTTON
                    GradientActionButton(
                      text: "Add Task",

                      onTap: () {

                        /// ADD TASK LOGIC

                        Navigator.pop(
                            context);
                      },
                    ),

                    const SizedBox(height: 14),

                    /// CANCEL
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                            context);
                      },

                      child: const Text(
                        "Cancel",

                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}