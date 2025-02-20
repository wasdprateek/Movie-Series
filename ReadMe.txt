In my application, I have implemented the following features

First of all, it is following the MVVM architecture and I tried to follow good coding practices

I have implemented API calls, using combines, zip function, and implemented a tab to switch between movies and TV series

I have also implemented pagination, but since the functions are called for movie and TV series together if one is loaded, the other one is also loaded. This increases the amount of network call, but in this case I am assuming that showing more movies is better than only showing one page of response. I have also implemented pull to refresh.

Since the list API of watch mode only returned the title year, and the IDs showing photos on the list view would take more API calls, so I made the UI as pleasing as possible with the available data and in the detail view of title I have shown the required information of every title

I have not worked with XCTest before so learning and implementing the test was a bit challenging, but since the app only has logic in calling the APIs and other than that, no other major functions are used so I am assuming that we need to check if the function that has API calls is working fine or not through tests, so I have done that.
If my tests are not good, it's because test are new to me and it will take a week for me to get more comfortable in XCTests I have also taken help from Internet and GPT in writing test.
