import 'package:cached_network_image/cached_network_image.dart';
import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  AuthenticationBloc _authenticationBloc;

  AppUser currentUser;

  @override
  void initState() {
    setdDrawerListArray();
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    fetchUser();
  }

  void fetchUser() async {
    AppUser user = await _authenticationBloc.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  void setdDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.ADMIN,
        labelName: 'Admin',
        icon: Icon(Icons.admin_panel_settings),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Help',
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.Legal,
        labelName: 'Privacy Policy',
        isAssetsImage: true,
        // icon: Icon(Icons.priva),
        imageName: 'assets/images/legal.png',
      ),
      // DrawerList(
      //   index: DrawerIndex.FeedBack,
      //   labelName: 'FeedBack',
      //   icon: Icon(Icons.help),
      // ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: 'Invite Friend',
        icon: Icon(Icons.share),
      ),
      // DrawerList(
      //   index: DrawerIndex.Share,
      //   labelName: 'Rate the app',
      //   icon: Icon(Icons.share),
      // ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'About Us',
        icon: Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: widget.iconAnimationController,
                        builder: (BuildContext context, Widget child) {
                          return ScaleTransition(
                            scale: AlwaysStoppedAnimation<double>(1.0 -
                                (widget.iconAnimationController.value) * 0.2),
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation<double>(
                                  Tween<double>(begin: 0.0, end: 24.0)
                                          .animate(CurvedAnimation(
                                              parent: widget
                                                  .iconAnimationController,
                                              curve: Curves.fastOutSlowIn))
                                          .value /
                                      360),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.6),
                                        offset: const Offset(2.0, 4.0),
                                        blurRadius: 8),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(60.0)),
                                  child: currentUser != null &&
                                          currentUser.photoUrl != null
                                      ? Material(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100.0)),
                                          clipBehavior: Clip.hardEdge,
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        AppTheme.nearlyBlue),
                                              ),
                                              width: 100,
                                              height: 100,
                                              padding: EdgeInsets.all(15.0),
                                            ),
                                            imageUrl: currentUser.photoUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(
                                          Icons.account_circle,
                                          size: 100,
                                          color: AppTheme.nearlyWhite
                                              .withOpacity(.7),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          currentUser != null ? currentUser.name : '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.grey,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Divider(
                height: 1,
                color: AppTheme.grey.withOpacity(0.6),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(0.0),
                  itemCount: drawerList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return inkwell(drawerList[index]);
                  },
                ),
              ),
              Divider(
                height: 1,
                color: AppTheme.grey.withOpacity(0.6),
              ),
              Column(children: <Widget>[
                ListTile(
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppTheme.darkText,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  trailing: Icon(
                    Icons.power_settings_new,
                    color: Colors.red,
                  ),
                  onTap: () {
                    /**Handle user Signout */
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(ClickedLogout());
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? AppTheme.getPrimaryColor()
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? AppTheme.getPrimaryColor()
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? AppTheme.getPrimaryColor()
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.getPrimaryColor().withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  ADMIN,
  FeedBack,
  Legal,
  Help,
  Share,
  Settings,
  About,
  Invite,
  Testing
}

class DrawerList {
  DrawerList(
      {this.isAssetsImage = false,
      this.labelName = '',
      this.icon,
      this.index,
      this.imageName = ''});

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
