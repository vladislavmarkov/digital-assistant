#include <cstdlib>

#include "imgui.h"
#include <SFML/Graphics.hpp>

int
main(int /* unused */, char** /* unused */)
{
    sf::RenderWindow window(sf::VideoMode(800, 600), "Digital Assistant");

    // Start the game loop
    while (window.isOpen()) {
        // Process events
        sf::Event event;
        while (window.pollEvent(event)) {
            // Close window: exit
            if (event.type == sf::Event::Closed) { window.close(); }
        }
        // Clear screen
        window.clear();
        // Update the window
        window.display();
    }

    return EXIT_SUCCESS;
}
