import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xpenso/BLoC/validation_bloc.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

// Controllers for the Text Fields 1.Amount 2.Notes
TextEditingController amountController = TextEditingController();
TextEditingController notesController = TextEditingController();
//Validator
bool amountValid = true;
final validatorBloc = ValidatorBloc();

List<bool> selectedIndex1 = List.filled(30, false);

class AddCredit extends StatefulWidget {
  final bool iscredit;
  final Function()? onPressed;
  final Function()? onPressedAt;
  final String submitButtonName;
  final List<Widget> list;
  const AddCredit(
      {super.key,
      required this.onPressed,
      required this.submitButtonName,
      required this.list,
      required this.iscredit,
      this.onPressedAt});

  @override
  State<AddCredit> createState() => _AddCreditState();
}

class _AddCreditState extends State<AddCredit> {
  @override
  void initState() {
    super.initState();
    amountController.clear();
    notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SizedBox(
        height: bottomDrawerHeight,
        child: Column(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.cancel_rounded,
                  color: appColor,
                )),
            const SizedBox(
              height: height10,
            ),
            //******************************* Heading Amount Text ************************/
            const MyText(
              content: 'Enter Amount *',
              size: fontSizeSmall,
            ),
            const SizedBox(
              height: height20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: height10 / 2,
                ),
                SizedBox(
                  width: deviceWidth / 4,
                  child: MyButton(
                    textSize: fontSizeSmall,
                    content: const MyText(
                        content:
                            '- 100'), // Button to subtract -100 form the textfield
                    onPressed: () {
                      if (amountController.text.isNotEmpty) {
                        int tmp = int.parse(amountController.text);
                        if (tmp > 100) {
                          tmp -= 100;
                          setState(() {
                            amountController.text = tmp.toString();
                          });
                        } else {
                          setState(() {
                            amountController.clear();
                          });
                        }
                      }
                    },
                    rad: height10 / 2,
                    fillColor: transparent,
                  ),
                ),
                //******************************* Amount Text Box  ************************/
                SizedBox(
                  height: height50,
                  width: deviceWidth / 2.3,
                  child: StreamBuilder(
                      initialData: false,
                      stream: validatorBloc.stateStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            errorText: amountValid == snapshot.data!
                                ? 'Amount Should not be Empty'
                                : null,
                            contentPadding: const EdgeInsets.all(height10 / 2),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height10 / 2)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                amountController.clear();
                              },
                              icon: const Icon(Icons.clear_rounded),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  width: deviceWidth / 4,
                  child: MyButton(
                    textSize: fontSizeSmall,
                    content: const MyText(
                        content: '+ 100'), // Button to add 100 to the textfield
                    onPressed: () {
                      amountController.text.isEmpty
                          ? amountController.text = '0'
                          : amountController.text;
                      int tmp = int.parse(amountController.text);
                      tmp += 100;
                      setState(() {
                        amountController.text = tmp.toString();
                      });
                    },
                    rad: height10 / 2,
                    fillColor: transparent,
                  ),
                ),
                const SizedBox(
                  width: height10 / 2,
                ),
              ],
            ),
            //******************************* Heading Category Text ************************/
            const SizedBox(
              height: height30,
            ),
            const MyText(size: fontSizeSmall, content: 'Choose Category'),
            const SizedBox(
              height: height10,
            ),
            //******************************* Category List *******************************/
            Container(
                padding: const EdgeInsets.symmetric(horizontal: height30),
                height: height75,
                width: deviceWidth,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) {
                    return Container(
                        width: height75,
                        decoration: BoxDecoration(
                            color: selectedIndex1[index]
                                ? Colors.grey.shade100
                                : transparent,
                            borderRadius: BorderRadius.circular(height10),
                            border: Border.all(
                              color: selectedIndex1[index]
                                  ? Colors.black
                                  : transparent,
                            )),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                selectedIndex1 = List.filled(30, false);
                                selectedIndex1[index] = !selectedIndex1[index];
                                catIndex = index;
                              });
                              debugPrint(
                                  'Seleted Category Sucessfully $index ${selectedIndex1[index]}');
                            },
                            icon: widget.list[index]));
                  },
                )),
            const SizedBox(
              height: height20,
            ),
            //******************************* Notes And Attachments************************/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: height10,
                ),
                SizedBox(
                  width: deviceWidth * 0.65,
                  child: TextFormField(
                    controller: notesController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(height10),
                      hintText: 'Enter Notes (Optional)',
                      hintStyle: const TextStyle(fontSize: fontSizeSmall),
                      suffixIcon: IconButton(
                          onPressed: () {
                            notesController.clear();
                          },
                          icon: const Icon(Icons.clear_rounded)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: height10,
                ),
                IconButton(
                    onPressed: widget.onPressedAt,
                    icon: const Icon(
                      Icons.attachment_outlined,
                      size: deviceWidth * 0.1,
                    )),
                const SizedBox(
                  width: deviceWidth * 0.01,
                ),
              ],
            ),
            //******************************* Save button ************************/
            const SizedBox(
              height: height30,
            ),
            MyButton(
                fillColor: appColor,
                textSize: fontSizeSmall,
                width: deviceWidth * 0.65,
                content: MyText(content: widget.submitButtonName),
                onPressed: widget.onPressed)
          ],
        ),
      ),
    );
  }
}
