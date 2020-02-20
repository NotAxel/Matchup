import 'package:test/test.dart'; 
import 'package:matchup/Widgets/timeStamp.dart'; 

void main(){
  group("formatTimeStamp", (){
    // for local time on US west coast, the expected should be 11:32 AM
    // for GMT/UTC it should be 7:32 PM
    // tested and works, but skip during the build since it will not work
    // on both local and travis
    test('given an integer time stamp, returns formatted datetime', (){
      // ARRANGE
      int timeStamp = 1580239938614;
      String expectedDate = "28 Jan 2020 7:32 PM" ;
      String actualDate;
      
      // ACT
      actualDate = TimeStamp.formatTimeStamp(timeStamp);

      // ASSERT
      expect(actualDate, expectedDate);
    }, skip: true);

    test('given a null time stamp, returns empty string', (){
      // ARRANGE
      int timeStamp;
      String expectedDate = "";
      String actualDate;
      
      // ACT
      actualDate = TimeStamp.formatTimeStamp(timeStamp);

      // ASSERT
      expect(expectedDate, actualDate);
    });
  });
}