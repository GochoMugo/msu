
# console

```bash
msu_require "console"
```

Handling console/output operations.


## write_text(text [, color_index=0])

Writes the text `text` to the console using the color indexed with `color_index`.

Color indices:

* 0 - blue
* 1 - green
* 2 - red


## log(message)

Writes the message `message` using the color blue.


## success(message)

Writes the message `message` using the color green.


## error(message)

Writes the message `message` using the color red.


## tick(label)


Writes the label `label` using the color green and a tick in front of it.

## cross(label)

Writes the label `label` using the color red and a cross (x) in front of it.


## list(label)

Writes the label `label` using the color blue with a right-arrow in front of it.


## ask(question, destinationVariable [, clear=0])

Asks the question `question` to the user with the answer being stored in the variable `${destinationVariable}`. If `clear` is set to `1`, the input is considered a password and will be hidden.


## yes_no(question [, default="N"])

Asks the yes/no question `question` to the user returning `0` for **yes** or `1` for **no**. If `default` is set to `"Y"`, the **yes** will be the default answer.
