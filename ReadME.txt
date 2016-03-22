Project Name: TaxME

TaxME application allows you to perform the following features:
1. Get sales tax and use tax for your current location
2. Get sales tax and use tax for desired zipcode
3. Calculate in hand salary after deductions as per the state taxes and respective salary bracket
4. Send feedback to the user via email in the app itself
5. Read about the app and the developer

Once the App is started, user can see 4 options:
Check Tax, Calculate Salary, Send Feedback and About Us.
1. If user selects option 1 i.e. Check Tax, user can see 2 more options in the next view- 
Current location: wherein the app will calculate the current position of the user on its own and display the taxes.
Other location: Here the user can enter the desired zipcode and check the taxes for the same. 
If the current location or the entered zipcode is outside USA, App will not give the tax informations as it is restricted for USA regions only.

2. Is user selects “Calculate Salary” option, the next view will ask the user to fill up certain details on the basis of which the app can calculate the deductions and in hand salary post state taxes depending on factors like- salary bracket, marital status and state.

3. If user select “Send Feedback”, the next view would open an email window. That would have by default Addresses and Subject line. User can send feedback on a click via email using the app

4. Finally, if the user wants to know About the app or the developers, he can use “About Us” option.

5. The database that we have made and used has information about taxes as per the state, marital status and salary bracket.

6. We have used an API that takes zipcode as an input and provides an XML with tax rates for that zipcode which we then parse and give filtered output.
