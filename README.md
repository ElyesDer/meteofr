# meteofr

## Overview

- Uses Reactive programming with UIKit and Combine
- Uses Async / Await (iOS13) for Data Synchronisation.
- Views are 100% coded programmaticaly.
- Uses Github Actions CI for `Continuation Integration`

## Design Pattern - Architecture

Project build with Clean Architecture Principales.

- Data Synchronisation are handled using a Repository Pattern that guarante data automatically from cache or from api based on avaibility.  

### Design-Pattern 

Built in `MVVM` with Depencies Injection.

#### Choices behind

While `MVC` could have be a simpler solution, Dependencies Injection was the best solution for a project targeting `Testing First Principales`.

#### Architecture and Design Pattern
## Features

- [x] iOS Application using Reactive Programming with Combine Framework in a `MVVM` pattern.
- [x] Network and Datalayer Unit Testing with Test Driven Devlopment.
- [x] Uses `AutoLayout` Constraint programmatically. 0 Interface Builder (.storyboard / .xib).
- [x] Display data using modern `UICollectionViewDiffableDataSource` & `UITableViewViewDiffableDataSource`.
- [x] `SOLID` Principales 
- [x] Support `Swiftlint`.
