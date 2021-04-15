Feature: Furniture: Markdown Text Block
  In order to communicate with the written word
  I want a Markdown Text Block


  @built @unimplemented-steps
  Scenario: Viewing Markdown
    Given a Room with a Markdown Text Block with the following Content:
      """
    ## Fancy Pants

    Everyone has pants!

    But not everyone has _fancy pants!_

    [Like the GRINCH](https://google.com/)

    **FANCY PANTS** for _ALL_!
      """
    Then people in that Room see the following HTML:
      | <h2>Fancy Pants</h2>                                    |
      | <p>Everyone has pants!</p>                              |
      | <p>But not everyone has <em>fancy pants!</em>           |
      | <p><a href="https://google.com">Like the GRINCH</a></p> |
      | <strong>FANCY PANTS</strong>                            |
      | <em>ALL</em>                                            |
