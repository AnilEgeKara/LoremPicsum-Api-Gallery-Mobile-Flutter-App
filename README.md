# LoremPicsum Api Gallery Flutter Mobile App

In this project, I used API to get data from Lorem Picsum's image list URL.

![](https://media.giphy.com/media/RhgKxFUOF7PS5lsnEC/giphy.gif)

There is two design for viewing image. You can switch between by the switch button at the left top corner.

For first one ,I design an AlertDialog to show a specific image with its data that came from API. In this AlertDialog we can rotate the image in x and y dimensions with help of the Transform widget. We can go to the official site of the image by clicking the visit link.

![](https://media.giphy.com/media/P2W6RTiLn4ZT2QPzbb/giphy.gif)
![](https://media.giphy.com/media/YIMV3VAxgHYYpLrFRz/giphy.gif)

The other one is opening a new route and passes the API information as arguments. In here we can zoom in and out by gesture control or zoom 2x by double-tap. We can see the image details on the bottom sheet. 

![](https://media.giphy.com/media/dGKk94aHKeNsz9OIt3/giphy.gif)
![](https://media.giphy.com/media/WCPgpe0hZ1KNQnWXOG/giphy.gif)

# Packages 

https://pub.dev/packages/http for API <br>
https://pub.dev/packages/url_launcher for launching url in browser <br>
https://pub.dev/packages/font_awesome_flutter for Icons
