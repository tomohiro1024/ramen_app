import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramen_app/components/badgeContainer.dart';
import 'package:ramen_app/detail/detail_page.dart';
import 'package:ramen_app/model/ramen_data.dart';

class RamenContainer extends StatefulWidget {
  const RamenContainer({
    super.key,
    required this.width,
    required this.ramen,
  });
  final double width;
  final RamenData ramen;

  @override
  State<RamenContainer> createState() => _RamenContainerState();
}

class _RamenContainerState extends State<RamenContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 5, horizontal: widget.width * 0.02),
      child: GestureDetector(
        onTap: () {
          context.push(
            '/detail',
            extra: {
              'ramen': widget.ramen,
              'width': widget.width,
            },
          );
        },
        child: Stack(
          children: [
            Container(
              height: widget.ramen.isOpen == true ? 165 : 140,
              decoration: BoxDecoration(
                color: widget.ramen.isOpen == true
                    ? Colors.white
                    : Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: Offset(1, 0.1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: widget.width * 0.03),
                      widget.ramen.photoUrl != null
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2.2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  widget.ramen.photoUrl!,
                                  width: widget.width * 0.29,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Image.asset(
                              'assets/images/sample.png',
                              width: widget.width * 0.29,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                      SizedBox(width: widget.width * 0.03),
                      SizedBox(
                        width: widget.width * 0.47,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Row(
                              children: [
                                BadgeContainer(
                                    isOpen: widget.ramen.isOpen ?? false,
                                    width: widget.width),
                                SizedBox(width: widget.width * 0.01),
                                Visibility(
                                  visible: widget.ramen.isTop == true,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.redAccent,
                                      ),
                                      Text(
                                        "おすすめ！",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.ramen.name ?? '店名不明',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Transform.translate(
                                    offset: Offset(0, 10),
                                    child: Text("レビュー評価：")),
                                Text(
                                  widget.ramen.rating != null
                                      ? widget.ramen.rating!.toString()
                                      : '',
                                  style: TextStyle(
                                    fontSize: 45,
                                    color: Color(0xFFFFC107),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 45,
                        color: Colors.cyan,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: widget.ramen.isOpen == true,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(widget.width * 0.04, 7, 0, 0),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/human.png',
                                width: widget.width * 0.05,
                                height: 19,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: widget.width * 0.02),
                            Expanded(
                              child: Text(
                                widget.ramen.reviews?.text ?? 'レビューなし',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: widget.ramen.isOpen == true
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.ramen.isOpen == true,
              child: Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 29,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
