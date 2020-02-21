import 'package:test/test.dart';
import 'package:matchup/bizlogic/message.dart';
main(){
  test('creating message object', (){
    String expectedContent = "foo";
    String expectedToId = '123';
    String expctedFromId = '456';
    int expectedTimeStamp = 123456789;

    Message message = Message("bar", '456', '123');

    message.setContent = expectedContent;
    message.setToId = expectedToId;
    message.setFromId = expctedFromId;
    message.setTimeStamp = expectedTimeStamp;

    expect(message.getContent, expectedContent);
    expect(message.getToId, expectedToId);
    expect(message.getFromId, expctedFromId);
    expect(message.getTimeStamp, expectedTimeStamp.toString());
  });
}