Example equation:
$$f(x) = \frac{1}{\sqrt{2\pi}} e^{-\frac{1}{2}(\frac{x-\mu}{\sigma})}$$

Example code:

    d <- dnorm(0, 0, 1) %>% round(3)
    d

    ## [1] 0.399

We can show that something is code by enclosing it in backticks. Above
we used the function `dnorm()`.

We can run inline code by enclosing it in backticks starting with `r`:
the value of `d` is 0.399.

The value of `exp(1)` is 2.7182818.

Here is a horizontal line:

------------------------------------------------------------------------

Now it’s time for an image:

![](comparison_chart.png)
