Feature: Furniture: Markdown Text Block
  In order to communicate with the written word
  I want a Markdown Text Block


  Scenario Outline: Updating the Markdown Text Block
    Given a Room with a Markdown Text Block
    When an <actor> sets the following content:
      """
    ## Fancy Pants

    Everyone has pants!

    But not everyone has _fancy pants!_

    **FANCY PANTS** for _ALL_!
      """
    Then people in that Room see the following HTML:
      | <h2>Fancy Pants</h2>                          |
      | <p>Everyone has pants!</p>                    |
      | <p>But not everyone has <em>fancy pants!</em> |
      | <strong>FANCY PANTS</strong>                  |
      | <em>ALL</em>                                  |

    Examples:
      | actor        |
      | Space Owner  |
      | Space Member |