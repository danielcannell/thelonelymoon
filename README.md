# The Lonely Moon
Ludum Dare 42 Game Jam

## Blurb
When astronomers noticed the moon getting a bit closer, they thought it was cute. "The Moon is lonely!", they said. "It's coming to give us a hug!". Only you understood what it means - that if the Moon gets too close, then the Earth's days are numbered...

Once you realised what to do, you quickly founded a start-up to build satellites and rockets, with the secret goal of building the ultimate space ship - The Ark. The Ark will be the ship to sail civilisation to another world (and most importantly, save you). The plan is simple - you will put satellites into orbit, and use the income they generate to fund research and development for The Ark. But be warned - things might not go quite to plan. Your satellites could collide and create fields of debris. The moon's gravity could modify your trajectories, and send your satellites spinning away. Antagonistic space agencies could shoot you down, and really ruin your day. You might quickly find yourself running out of space...

## How to Play
The objective of the game is to build The Ark and to sail it all the way to outer space. Good luck!

### The Shop
You can buy things (including satellites) with the shop. If you have enough bitcoin to spend, click a satellite and it will start building. Once the build is complete, it will launch from Earth.

Hover the mouse over the items in the shop to find out more about it - like how long it takes to build, and the starting income. Special shop items have usage instructions in their hover-text.

If you don't have any bitcoin, you can always hold a press conference to try and raise some money.

### Orbital Play
When a satellite launches, it will appear on a rocket and slowly head into orbit. You can select a satellite by creating a selection box around it with the mouse. Once selected, you can control the satellite by pushing 'W' to speed up and 'S' to slow down. The orbital trajectory is shown as a blue line, and the satellite target region is shown as a green ring. The satellite statistics are shown in the info box in the bottom-right of the screen (including fuel/delta-V remaining).

Remember, satellites will only make money while they are in their target area, and you have to move them there yourself! Your satellites income will decrease over time as they wear out, but you can boost your income by creating constellations of the same satellite type.

You'll receive notifications in the top-right of the screen when something interesting happens, like your satellite getting smashed to bits. Keep an eye on these. You can also view statistics about the whole game by opening the "Orbital Statistics" screen. You can find that button in the bottom-left of the screen.

### Endgame
If you manage to make enough money before the moon gets too close and starts wreaking havoc, then you can launch The Ark! To win, simply sail it out to the target region.


## Publishing

Open the project in Godot and select `Project > Export`. Click `Export Project` in the bottom-left. Navigate to a checkout of
https://github.com/TheLonelyMoon/thelonelymoon.github.io, set the `File` name to
`index.html`, and click `Export`. Commit the changes and push.
