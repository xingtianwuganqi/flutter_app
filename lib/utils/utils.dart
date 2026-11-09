/// 实用工具类
/// 这个文件包含项目中常用的实用函数和工具方法

class Utils {
  /// 示例工具方法：检查字符串是否为空或null
  static bool isNullOrEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  /// 示例工具方法：安全地截取字符串
  static String safeSubstring(String str, int startIndex, {int? endIndex}) {
    if (str.isEmpty) return '';
    
    int actualEndIndex = endIndex ?? str.length;
    actualEndIndex = actualEndIndex > str.length ? str.length : actualEndIndex;
    
    if (startIndex >= actualEndIndex || startIndex < 0) return '';
    
    return str.substring(startIndex, actualEndIndex);
  }

  /// 示例工具方法：格式化时间戳为日期字符串
  static String formatDate(DateTime date) {
    return "${date.year}-${_formatNumber(date.month)}-${_formatNumber(date.day)}";
  }

  /// 辅助方法：格式化数字为两位数
  static String _formatNumber(int number) {
    return number < 10 ? "0$number" : "$number";
  }
}