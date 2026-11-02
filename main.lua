
function love.load()
    love.window.setTitle("Pong Game")
    love.window.setMode(800,600) -- Width x Height

    --Paddle and ball constants
    local PADDLE_WIDTH = 20
    local PADDLE_HEIGHT = 100
    local BALL_SIZE = 20

    score1 = 0
    score2 = 0
    scoreFont = love.graphics.newFont(40)
    messageFont = love.graphics.newFont(22)

    --Left paddle
    player1 = {
        x = 50,
        y = 240,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = 300
    }

    -- Right paddle
    player2 = {
        x = 800 - 50 - PADDLE_WIDTH,
        y = 250,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = 300
    }

    --Ball
    ball = {
        x = 400 - BALL_SIZE/2,
        y = 300 - BALL_SIZE/2,
        size = BALL_SIZE
    }

    -- Initial speed for the ball
    ball.dx = 200 -- Horizontal speed
    ball.dy = 200 -- Vertical speed
    ball.served = false -- Ball waits for Space

end

function love.draw()
    --Set background color
    love.graphics.setBackgroundColor(0.1,0.1,0.1)

    --Draw the dashed line at center
    love.graphics.setColor(1,1,1)
    for i = 0, 600, 30 do
        love.graphics.rectangle("fill",395,i,10,15)
    end

   
    -- Draw paddles
    love.graphics.setColor(0.2,0.5,1) -- Blue paddle
    love.graphics.rectangle("fill",player1.x,player1.y, player1.width,player1.height)

    love.graphics.setColor(1,0.3,0.3) -- Red paddle
    love.graphics.rectangle("fill",player2.x,player2.y, player2.width,player2.height)

    --Draw ball
    love.graphics.setColor(1,1,1) -- White ball
    love.graphics.rectangle("fill",ball.x,ball.y, ball.size, ball.size)

    love.graphics.setFont(scoreFont)

    --Draw our scores
    love.graphics.print(score1, 300, 50)
    love.graphics.print(score2, 470, 50)

    
    -- Show serve message
    if not ball.served then
        love.graphics.setFont(messageFont)
        love.graphics.printf("Press SPACE to Start", 0, 520, 800, "center")
    end

end


local function checkCollision(ball,paddle)
    return ball.x <= paddle.x + paddle.width and
           ball.x + ball.size >= paddle.x and
           ball.y <= paddle.y + paddle.height and
           ball.y + ball.size >= paddle.y
end


local function resetBall()
    ball.x = 400 - ball.size/2
    ball.y = 300 - ball.size/2
    ball.dx = 200 * (math.random(2) == 1 and 1 or -1)
    ball.dy = 200 * (math.random(2) == 1 and 1 or -1)
end


function love.update(dt)

    if love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed * dt
    elseif love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed * dt
    end

    if love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed * dt
    elseif love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed * dt
    end

    --Move ball only after pressing Space
    if ball.served then
        ball.x = ball.x + ball.dx * dt
        ball.y = ball.y + ball.dy * dt
    end

    -- Bounce off top and bottom walls
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    elseif ball.y + ball.size >= 600 then
        ball.y = 600 - ball.size
        ball.dy = -ball.dy
    end

    if ball.dx < 0 and checkCollision(ball,player1) then
        ball.x = player1.x + player1.width -- Preventing overlap
        ball.dx = -ball.dx * 1.05 -- Bounce and speed up slightly
    end

    if ball.dx > 0 and checkCollision(ball,player2) then
        ball.x = player2.x - ball.size -- Preventing overlap
        ball.dx = -ball.dx * 1.05 -- Bounce and speed up slightly
    end

    if ball.x + ball.size < 0 then
        score2 = score2 + 1
        resetBall()
    elseif ball.x > 800 then
        score1 = score1 + 1
        resetBall()
    end

    -- Keep paddles inside screen
    player1.y = math.max(0, math.min(player1.y, 600 - player1.height))
    player2.y = math.max(0, math.min(player2.y, 600 - player2.height))

end

function love.keypressed(key)
    if key == "space" and not ball.served then
        ball.served = true
    end
end