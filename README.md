# Demo

This application is showing how to call an api using URLSession and using CoreData as Persistence. Also using MVVM as a design Pattern

## MVVM
Cons
- MVVM facilitates easier parallel development of a UI and the building blocks that power it.
- MVVM abstracts the View and thus reduces the quantity of business logic (or glue) required in the code behind it.
- The ViewModel (being more Model than View) can be tested without concerns of UI automation and interaction.

Pros
- For simpler UIs, MVVM can be overkill.
- Similarly in bigger cases, it can be hard to design the ViewModel.
- Debugging would be bit difficult when we have complex data bindings.

## CoreData

I've use CoreData to save favorites track and UserDefaults to save the date last visited of the user to the app. It will be viewed at top left corner of the Track List Screen.
