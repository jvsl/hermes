# Peek Code Challenge
## Architecture
###### - MVVM

## Features
- Pagination
- Error handler
- Offline mode

# Develoment

Some abstractions were developed to decouple the Network layer from Apollo framework. To achieve that, a protocol called “Fetching” was built, as well as a struct called “Fetcher” to implement that protocol. The struct "Fetcher" instanciates Apollo's client. Thus, if the network changes its concrete type, the clients that use the "Fetching" protocol will not be affected.

# Offline mode
In order to establish a minimum offline experience, the abstractions “RemoteLoader” and “LocalLoader” were created. The GithubGraphQLLoader struct holds the refereces for those loaders. If the device is connected to the internet, the loader will fetch data from remote url, otherwise, it will get data from cache.

# View
The view was built by using View Code. A protocol called ViewConding was created to avoid crashes while building constraints. It consists in a template method pattern that calls, in the correct order, the proccess to handle contraints: addSubview -> addConstraints -> buildView.
The error view (FullScreenErrorView) presents a button to retry and a message.

# ViewModel
The viewModel handles calls to search(first time), nextPage calls and a delegate to respond VC demands.

## Third libraries
-  [LLSpinner](https://github.com/alephao/LLSpinner)
Simple fullscreen view spinner.
- [Kingfisher](https://github.com/onevcat/Kingfisher)
Tool to download, cache, prefetch and set images/placeholders in a UIImageView.
- [SnapKit](https://github.com/SnapKit/SnapKit)
Tool to build constraints easily.
No need to set translatesAutoresizingMaskIntoConstraints = false
Very simple sintax. Concatenate constraints, such as view.width.height.equalToSuperView(), view.center.equalToSuperView(), etc.
- [Cosmos](https://github.com/evgenyneu/Cosmos)
A view with stars for rating. It possible to set a double value and according it a view with stars is filled.
- [Reachability](https://github.com/ashleymills/Reachability.swift)
Library that returns whether the device is connected to the internet or not.

## Improviments
- Some reactive framework, such as RXSwift or Combine, fit well with that type of problem;
- A better approach for loading when the next page is being called. Some loading in a cell could improve the UX;
- Retry after an error could have a number of maximum retries possible;
- The internet connection verification could be performed each request made;
- A coordinator to handle navigation removing that role from the ViewController;
- More abstractions. For example: abstration for Kingfisher;
- For other search, remove the harcoded phrase;
- Add the Strings in the Localizable file;
- More Unit Tests;
- More detais in this file;
