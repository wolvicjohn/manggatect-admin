class MapUtils {
  static String getIconPath(String stage) {
    switch (stage) {
      case 'stage-1':
        return 'assets/images/tree_icon.png';
      case 'stage-2':
        return 'assets/images/stage1_icon.png';
      case 'stage-3':
        return 'assets/images/stage2_icon.png';
      case 'stage-4':
        return 'assets/images/stage3_icon.png';
      default:
        return 'assets/images/no_flower.png';
    }
  }
}
