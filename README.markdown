Gchat Trained Markov Chains
===========================

An application that aims to autocomplete your chat sentences. Uses the IMAP protocol to connect to your gmail and pull your gchat history for the last 90 days.

### To run

    bundle install
    bin/fetch_chats # Only first time
    bin/autocomplete

Pulls and parses chat history then spits out gibberish! Currently outputs a 50
word markov chain generated string based on your chat history.
