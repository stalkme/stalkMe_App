import 'package:flutter/material.dart';
import 'package:stalkme_app/util/deviceSize.dart' as deviceSize;
import 'package:stalkme_app/util/userInfo.dart' as userInfo;

class Filter {
  Filter(this.name, this.image);
  final String name;
  final AssetImage image;
}

class FilterTab extends StatefulWidget {
  @override
  _FilterTabState createState() => _FilterTabState();
}

class _FilterTabState extends State<FilterTab>
    with SingleTickerProviderStateMixin {
  List<Filter> filters = List();
  Filter activeFilter;
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  Animation<Color> _iconColorAnimation;

  @override
  void initState() {
    super.initState();
    filters.add(Filter('GRILL', AssetImage('assets/filterGraphics/grill.jpg')));
    filters.add(
        Filter('LEARNING', AssetImage('assets/filterGraphics/learning.jpg')));
    filters
        .add(Filter('COFFEE', AssetImage('assets/filterGraphics/coffee.jpg')));
    filters.add(
        Filter('CLIMBING', AssetImage('assets/filterGraphics/climbing.jpg')));
    filters.add(Filter('BEER', AssetImage('assets/filterGraphics/beer.jpg')));
    filters.add(
        Filter('DRIVING', AssetImage('assets/filterGraphics/driving.jpg')));
    filters.add(Filter(
        'VOLLEYBALL', AssetImage('assets/filterGraphics/volleyball.jpg')));
    filters.add(Filter(
        'DOG WALKING', AssetImage('assets/filterGraphics/dog_walking.jpg')));
    filters.add(
        Filter('FOOTBALL', AssetImage('assets/filterGraphics/football.jpg')));
    filters.add(Filter(
        'BASKETBALL', AssetImage('assets/filterGraphics/basketball.jpg')));
    filters.add(
        Filter('PARTYING', AssetImage('assets/filterGraphics/partying.jpg')));
    filters.add(
        Filter('RUNNING', AssetImage('assets/filterGraphics/running.jpg')));
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _colorAnimation = ColorTween(begin: Colors.transparent, end: Colors.grey)
        .animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
    _iconColorAnimation = ColorTween(begin: Colors.transparent, end: Color(0x44ffffff)).animate(_animationController);
  }

  Widget filterTile(Filter filter) {
    return GestureDetector(
      key: Key(filter.name),
      onTap: () {
        if (activeFilter == filter) {
          activeFilter = null;
          userInfo.filterName = "Default";
          _animationController.animateTo(0);
        } else {
          setState(() {
            userInfo.filterName = filter.name;
            _animationController.value = 0;
            activeFilter = filter;
            _animationController.animateTo(1);
          });
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            width: deviceSize.size.width * 0.16,
            height: deviceSize.size.width * 0.16,
            decoration: BoxDecoration(
              color: (activeFilter == filter)
                  ? _colorAnimation.value
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Container(
              width: deviceSize.size.width * 0.16,
              height: deviceSize.size.width * 0.16,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    colorFilter: (filter == activeFilter) ? ColorFilter.mode(_iconColorAnimation.value, BlendMode.lighten) : null,
                    image: filter.image,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )),
            ),
          ),
          Text(
            filter.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: deviceSize.size.width * 0.042,
              fontFamily: "Roboto",
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(filters.length, (int index) {
        return filterTile(filters[index]);
      }),
    );
  }
}
