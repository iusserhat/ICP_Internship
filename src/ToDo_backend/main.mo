import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

actor Assistant {


  type ToDo = {
    description: Text;
    completed: Bool;
  };


  func natHash(n: Nat): Hash.Hash {

    Text.hash(Nat.toText(n))
  };


  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);

  var nextId: Nat = 0;

  public query func getTodos(): async [ToDo] {

    Iter.toArray(todos.vals());
  };


  public func addTodo(description: Text): async Nat {
    // Assign the current value of 'nextId' to 'id'.
    let id = nextId;
    // Insert a new to-do item into the 'todos' map with the given description and mark it as not completed.
    todos.put(id, { description = description; completed = false });
    // Increment 'nextId' for the next to-do item.
    nextId += 1;
    // Return the assigned ID.
    id
  };


  public func completeTodo(id: Nat): async () {
    // Ignore any errors that may occur during the execution.
    ignore do ? {
      // Retrieve the description of the to-do item with the given ID.
      let description = todos.get(id)!.description;
      // Update the to-do item's status to completed in the 'todos' map.
      todos.put(id, { description; completed = true });
    }
  };

  public query func showTodos(): async Text {
    // Initialize the output text with a header.
    var output: Text = "\n___TO-DOs___";
    // Iterate over each to-do item in the 'todos' map.
    for (todo: ToDo in todos.vals()) {
      // Append the description of the to-do item to the output text.
      output #= "\n" # todo.description;
      // If the to-do item is completed, append a check mark to the output text.
      if (todo.completed) { output #= " ✔"; };
    };

    output # "\n"
  };

  public func clearCompleted(): async () {
    // Filter out completed to-do items from the 'todos' map and update it accordingly.
    todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash, 
              func(_, todo) { if (todo.completed) null else ?todo });
  };
};
