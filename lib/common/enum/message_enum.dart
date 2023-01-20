enum MessageEnum {
  text('text'),
  image('image'),
  pdf('pdf');

  const MessageEnum(this.type);
  final String type;
}

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'image':
        return MessageEnum.image;
      case 'text':
        return MessageEnum.text;
      case 'pdf':
        return MessageEnum.pdf;
      default:
        return MessageEnum.text;
    }
  }
}
