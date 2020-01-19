import 'package:test/test.dart';
import 'package:matchup/bizlogic/message.dart';
main(){
  test('creating message object', (){
    String expectedContent = "foo";
    String expectedToId = '123';
    String expctedFromId = '456';

    Message message = Message("bar", '456', '123');

    message.setContent = expectedContent;
    message.setToId = expectedToId;
    message.setFromId = expctedFromId;

    expect(message.getContent, expectedContent);
    expect(message.getToId, expectedToId);
    expect(message.getFromId, expctedFromId);
  });
}