IntroPage (intro_page.dart): Functionality: This is usually the start page of the app, which shows some animation or company logo before the topic, as the user lands on the login page or home page. Design: Minimalistic, focuses on introducing the brand using logos, animations or interactive elements. This is the first thing the user sees when launching the app.


![Screenshot 2024-09-04 170322](https://github.com/user-attachments/assets/6ac743a3-3930-423a-8ad4-fa3e70eebada)


Main (main.dart):
Functionality: The main file that initializes the application. This is where root routes, the application's initial page, and global settings like theme and state management are typically set. Design: This file likely doesn't have its own user interface, but is responsible for rendering the initial page and coordinating between different screens.


Login Page (login.dart):
Functionality: This is the login page. The user can log in with an email and password or use third-party authentication services such as Google. Design: Includes text fields for entering an email and password, buttons for logging in, an animated image, and optional buttons for logging in via Google. There is also a button to go to the registration screen if the user is not logged in.


![Screenshot 2024-09-02 232139](https://github.com/user-attachments/assets/31ac1c71-1bc9-43a2-a552-3b0ab0667e83)


Registration Page (registration.dart):
Functionality: Registration page where the user can create a new account by filling out a form with fields for name, email and password. There is also a button for registering via a Google account. Design: A standard registration form with mandatory input fields and a button for submitting data. There is an animated image at the top. After registration, the user is redirected to the main page of the application.

![Screenshot 2024-09-02 232132](https://github.com/user-attachments/assets/054fd18a-4c41-40cf-b4dc-cd6e881ac748)


Shop Page (shop_page.dart):
Functionality: A page with products where the user can view and add them to the cart. It also includes the functionality of searching, filtering products, adding products to favorites, choosing the color, size and quantity of the product (as much as the user needs). There is also a button to search for a product and a button to display all products. Design: A page with product cards that displays the name, image, price and the option to add the product to the cart. There is an option to filter and search by products.


![Screenshot 2024-09-02 232333 - Copy](https://github.com/user-attachments/assets/7e041350-b877-4fa9-ae79-781d7b1f6c04)
![Screenshot 2024-09-02 232348 - Copy](https://github.com/user-attachments/assets/e9f195c4-a0f1-4eac-8f96-b0828944110d)
![Screenshot 2024-09-02 232354 - Copy](https://github.com/user-attachments/assets/6261b0f5-d147-47a8-98e2-abdba6d1a834)
![Screenshot 2024-09-02 232359](https://github.com/user-attachments/assets/1228f3b5-25a2-4537-b6f8-40e2f8afc4bc)
![Screenshot 2024-09-02 232425](https://github.com/user-attachments/assets/58f94511-38bf-4efe-842b-7f79c7f06cce)
![Screenshot 2024-09-02 232435](https://github.com/user-attachments/assets/b1cf4d0c-2cb7-46ea-a305-b94b39371ac5)
![Screenshot 2024-09-02 232439](https://github.com/user-attachments/assets/1b4cd8ee-6015-40d3-974e-fd4340dea61f)
![Screenshot 2024-09-02 232447](https://github.com/user-attachments/assets/4aeec566-a6c7-44e0-8a49-5af92466e4ee)
![Screenshot 2024-09-02 232505](https://github.com/user-attachments/assets/d1476ecb-a695-4ead-a384-4c3c6afaaffc)
![Screenshot 2024-09-02 232508](https://github.com/user-attachments/assets/e317088e-5393-4ac0-8f01-193e872ecae2)
![Screenshot 2024-09-02 232514](https://github.com/user-attachments/assets/44217851-618d-4ced-9f37-2e2f78b10512)
![Screenshot 2024-09-02 232520](https://github.com/user-attachments/assets/27a84302-b923-47d1-a7cc-05b174b102fb)




Favorites Page (favorites_page.dart):
Functionality: This is a page where products that the user has marked as favorites are displayed. Design: It is a list of products in the form of cards with images and basic information about each product.


![Screenshot 2024-09-02 232425](https://github.com/user-attachments/assets/666d0f36-58b3-40f6-b902-c6c93684c36a)
![Screenshot 2024-09-02 232430](https://github.com/user-attachments/assets/16d54783-104c-414d-b499-d49f886fea3c)



Cart Page (cart_page.dart):
Functionality: Cart page where the user can view the products added to the cart from the shop page, delete them, view the product properties that he has selected, view the total cost of the products at the bottom of the page and proceed to checkout. Design: List of products in the cart with a "Checkout" button to go to the checkout page. The total cost of the products in the cart is also displayed.

![Screenshot 2024-09-02 232533](https://github.com/user-attachments/assets/d9c235ae-fcd8-41fc-b930-91e8f656ef31)
![Screenshot 2024-09-02 232539](https://github.com/user-attachments/assets/f5b783f0-d7bb-41d0-8431-2689bfd09c73)
![Screenshot 2024-09-02 232617](https://github.com/user-attachments/assets/b030c633-e581-4356-8e31-6f6eb7536f31)

If the user wants to remove any item from the cart, it will be instantly removed and an animation with an empty cart and a caption will appear.

![Screenshot 2024-09-02 232546](https://github.com/user-attachments/assets/0f855e88-76e1-4518-976e-844707ba43f9)
![Screenshot 2024-09-02 232550](https://github.com/user-attachments/assets/6dda1ab6-ee37-46f0-9027-71c3a40251c1)


Payment Page (payment_page.dart):
Functionality: Payment page where the user enters their bank card details to complete the purchase. Design: Form for entering card details (card number, expiration date, CVV with a character limit (as in real payment)). After successful payment, a message about a successful transaction is displayed, and the cart is cleared.


![Screenshot 2024-09-02 232627](https://github.com/user-attachments/assets/530008d3-c75c-49de-a3e9-597fc85afd7e)
![Screenshot 2024-09-02 232617](https://github.com/user-attachments/assets/d24d9c59-dc75-4017-bbd7-7f9f1aa1be98)
![Screenshot 2024-09-02 232632](https://github.com/user-attachments/assets/a0c333f0-b319-4f42-941c-8255af1aa23b)




Purchased Items Page (PurchasedItemsPage.dart):
Functionality: A page that displays all the items that the user has purchased. Items are sorted by purchase time. Design: A sheet of items (item cards), where each card displays information about the item, such as name, quantity, purchase date, and an image of the item.


![Screenshot 2024-09-02 232652](https://github.com/user-attachments/assets/5249cdd7-a9be-404b-a8b5-632ac4f2e042)


Profile Page (profile_page.dart):
Functionality: The user profile page where their data such as name, avatar and current purchases are displayed. There may also be an option to log out of the account. Also, if the user has more than 3 items in the cart, then only 3 items are displayed and at the bottom there is a button (view all) that takes them to the cart with the further option to pay for these items. Design: The page contains a profile picture, username, cart information and a button to log out. There is also an option to upload a new profile picture.


![Screenshot 2024-09-02 232712](https://github.com/user-attachments/assets/0054f754-7953-4191-afcf-7f8b2ee96a9c)
![Screenshot 2024-09-02 232708](https://github.com/user-attachments/assets/51cc6743-f754-4385-b8bc-dded14f565db)
![Screenshot 2024-09-02 232641](https://github.com/user-attachments/assets/5c313817-eb96-4932-b810-8bbd175f9c80)
![Screenshot 2024-09-02 232716](https://github.com/user-attachments/assets/3b7ceb6f-1700-4a3c-b943-050026fc6286)


Home Page (home_page.dart):
Functionality: This is the main page of the app with navigation. It may contain buttons to go to the store page, cart, profile or "about us" page. Design: The main screen with a bottom navigation bar where icons for quick access to the main sections of the app are located.

![Screenshot 2024-09-02 232722](https://github.com/user-attachments/assets/58e1b3c9-cd3e-4fdd-9bd8-eac9a7409535)



About Page (about_page.dart):
Functionality: A page with information about the company that developed the app, as well as contact details for contacting support. Design: A basic information screen with text about the company, contact numbers, and email. Possibly a company logo is also present.


![Screenshot 2024-09-02 232726](https://github.com/user-attachments/assets/95e9ba8f-5d63-447d-a508-41e950e713c9)
![Screenshot 2024-09-02 232729](https://github.com/user-attachments/assets/85de2d56-7091-43ca-91ed-9e80ed1d594b)




Common elements:
Navigation: The application has a bottom navigation bar for quick transition between main pages (Shop, Cart, Profile). Also added is a Drawer, which allows you to navigate between sections, including the "About Us" page.
Color palette: The main color accent in the application is purple and gray, which creates a sense of simplicity and minimalism.
Lottie animations: Used to decorate and improve the user experience, for example, on pages where the cart is empty.
The application is quite functional, supports authorization, viewing products, adding to the cart, purchasing and working with the user profile.



