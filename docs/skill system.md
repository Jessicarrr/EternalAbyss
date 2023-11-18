# Skill System Design Document

## Table of Contents
1. [Introduction](#introduction)
2. [Intention of the Skill System](#intention-of-the-skill-system)
3. [Skill Progression Curve](#skill-progression-curve)
4. [Individual Skills Functionality](#individual-skills-functionality)
5. [Skill Leveling Mechanics](#skill-leveling-mechanics)
6. [Skill Synergies and Builds](#skill-synergies-and-builds)
7. [User Interface Considerations](#user-interface-considerations)
8. [Balancing and Adjustments](#balancing-and-adjustments)
9. [Future Considerations](#future-considerations)

## Introduction
This is the design document for the skill system that will be in this un-named Roguelike / roguelite game. 

## Intention of the Skill System
The skill system is intended to add diversity to each playthrough - allowing players to level up skills to make their character better at certain things. For example, levelling up the health skill will give the player a higher max health, so they can take more hits. Weapon skills might add more damage when the player uses those weapons. 

Players should be able to create different builds each playthrough, for which the intention is to make each playthrough feel different enough that the player might have fun with the game for a longer period of time.

## Skill Progression Curve
The skill progression curve will be calculated using the player's overall level. Players will start at level 1, and if they level up the health skill twice, they will now be level 3. For each overall level, levelling up becomes more expensive.

The idea behind this design choice is to make players think a little carefully about what skills they will choose to level up. Making them choose prevents players from becoming a "jack of all trades", because being a jack of all trades would make every playthrough more "same-y".

Because each skill level up will contribute to the cost of the next level up, no matter what skill the player chooses, I have chosen to make the skill progression curve rather light at first. Players will be able to level up relatively quickly in the beginning, but as they become stronger, it will gradually become more expensive. The idea is to strike a balance between progression not being too hard, while also not allowing the player to level up every skill easily.

## Individual Skills Functionality
Most skills will share similar functionality. They can be levelled up, and they can be modified.

### Modification
Skills will have the functionality to be modified - or offset. This can be used to buff certain skills or to add curses to the player. The maximum offset is currently 5. This means that if the player has a skill of 20 in blades, they can be boosted to a maximum of 25 for som extra damage, or cursed down to level 15 so you do a little less damage.
Skills will have a max level of 99 and a minimum level of 1.

### Skill List

#### Health
Determines how much damage the player can take. Will have added functionality to take into account the current player's health, as opposed to their overall health skill level. It will interact smoothly with the offset system.
Health level: this will determine the max hitpoints the player has. By default this will be 100. Adding 1 health level will give 5 hitpoints.
Hitpoints: The amount of damage the player can take before dying.
Offset: The offset of this skill will modify the max health the player can have.
Player's hitpoints will not regenerate naturally, and the player will need to drink potions or eat food in order to regenerate it. Certain traits or items or other things can boost health regen a little bit, giving the player a little bit of health regeneration.

#### One-handed
This skill will deal with the overall damage the player does with all one-handed weapons.
This will also influence the speed at which one handed weapons can be used.

#### Two-handed
This skill will deal with the overall damage does with all two-handed weapons.
This will also influence the speed at which two handed weapons can be used.

#### Blade
This skill will modify the damage done with all bladed weapons, such as swords, daggers, etc.

#### Blunt
This skill will modify the damage done with all blunt weapons, such as maces, hammers, etc.

#### Endurance
The endurance skill will manage the total amount of stamina the player will have. It will work a lot like health - in that 1 level in endurance will give the player 10 extra stamina.
Stamina will regenerate naturally, likely at 25% of the total stamina per second. So if a player has 100 stamina, they will regenerate 25 stamina per second. This makes levelling up stamina more useful, and avoids the problem with other games where investing in stamina doesn't increase the rate at which you recover stamina, making stamina a worse investment.

#### Intelligence
This skill will be implemented at a later date compared to the other skills, as I would like to work on the melee system first, to make it fun and rewarding, before I move on to a different style of play. Intelligence will work like health and endurance. 1 level of intelligence will add to the player's overall magicka pool (10 points). The magicka pool will be responsible for how many spells the player can cast. It is currently undecided if magicka will regenerate naturally or if the player will need to do something to get their magicka back.


### More skills to come
The skill system will begin with not many skills. This is to keep the design simple so that the current iteration of the game will be as refined as possible before moving on and adding more features. This is to ensure that the core game will be as fun as possible without having to add too many different things to bloat up the game and make it more complex.

## Skill Leveling Mechanics

Players will accumulate a currency known as "Clarity" through various in-game achievements such as defeating enemies, discovering hidden areas, or overcoming environmental challenges. This currency is then used to level up skills.

### Leveling Up

- To level up a skill, players must access the skill interface, which can be done at specific checkpoints or through an in-game menu.
- The cost in Clarity for leveling up a skill is determined by the player's overall level, calculated by summing the levels of all skills.
- The first few levels will be inexpensive to encourage initial character customization and growth, with the cost increasing gradually to add strategic weight to the decisions on which skills to enhance.

### Currency Acquisition

- Defeating a common enemy might yield a small amount of Clarity, while bosses or rare enemies offer a significant boost.
- Exploration and interaction with the environment, such as solving simple puzzles or breaking containers, will also reward players with Clarity, ensuring that even non-combat activities are valuable.

## Skill Synergies and Builds

Each skill is designed to function well on its own but can be combined with others to create powerful synergies.

### Building a Character

- Players are encouraged to experiment with different skill combinations to discover powerful synergies.
- For example, investing in both One-handed and Blade skills will yield a character proficient in quick, sharp attacks, while a combination of Health and Endurance creates a tank-like build.

### Encouraging Synergies

- The game will subtly encourage synergistic builds through the design of challenges and enemies that may be easier to overcome with specific skill combinations.
- Traits or items found within the game can enhance certain skills or skill combinations, further promoting experimentation with builds.

## User Interface Considerations

The user interface (UI) for the skill system will be intuitive and informative, providing players with clear information while maintaining immersion.

### UI Design

- The skill interface will display all available skills, their current level, the cost to level up, and the benefits of the next level.
- Tooltips will provide detailed descriptions of each skill and its effects, ensuring players understand the impact of their investments.

### Accessibility

- The UI will be designed with accessibility in mind, with clear fonts, high contrast, and support for colorblind modes where necessary.
- Controls for navigating the skill interface will be simple and consistent with the rest of the game's controls.

## Balancing and Adjustments

The balance of the skill system is crucial to ensure that the game is challenging yet fair, and will be achieved through continuous playtesting and feedback.

### Playtesting

- Regular playtesting sessions will be conducted to gather data on how players use and perceive the skill system.
- Difficulty curves will be adjusted based on player progression speed and the diversity of successful builds.

### Feedback Loops

- Community feedback will be considered to identify any skills that are underused or overpowered.
- Adjustments will be made iteratively, with minor changes to prevent destabilizing the skill system's overall balance.

## Future Considerations

The skill system is designed to be flexible and expandable, with the potential for future growth and integration with new game mechanics.

### Expansion Plans

- Additional skills and modifications to existing skills are planned for future updates, keeping the game fresh and engaging.
- Compatibility with new content, such as DLCs or expansions, will be a priority, ensuring that the skill system remains relevant and integrated.

### Longevity

- The skill system will include hidden depths and complexities to be discovered over time, encouraging long-term engagement with the game.
- Future game modes or challenges may focus on specific skills or builds, adding new layers of strategy to the skill system.

Remember to ensure that all sections align with the game's vision and provide enough detail to guide the development process while remaining flexible to accommodate future changes.

