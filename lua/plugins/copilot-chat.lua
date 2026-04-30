return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      { "nvim-telescope/telescope.nvim" }, -- for telescope integration
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      debug = false, -- Enable debugging
      -- See Configuration section for rest
      model = "claude-sonnet-4.5", -- GPT model to use
      temperature = 0.1,

      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",

      auto_follow_cursor = false, -- Don't follow the cursor after getting response
      show_help = true, -- Show help in virtual text for @workspace and other context

      -- Use built-in contexts for workspace awareness
      -- Available: buffer, buffers, files, register, url

      -- Prompts for workspace operations
      prompts = {
        Explain = "Explain how this code works.",
        Review = "Review the following code and provide suggestions for improvement.",
        Tests = "Write tests for the following code.",
        Refactor = "Refactor the following code to improve its clarity and readability.",
        FixDiagnostic = "Please assist with the following diagnostic issue in the file.",
        Commit = "Write commit message for the change with commitizen convention.",
        CommitStaged = "Write commit message for the change with commitizen convention.",
        -- Custom workspace-aware prompts
        Workspace = "Analyze the entire workspace and suggest improvements.",
      },
      mappings = {
        -- Use tab for completion
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        -- Close the chat
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        -- Reset the chat buffer
        reset = {
          normal = "<C-l>",
          insert = "<C-l>",
        },
        -- Submit the prompt to Copilot
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        -- Accept the diff
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        -- Yank the diff in the response to register
        yank_diff = {
          normal = "gy",
        },
        -- Show the diff
        show_diff = {
          normal = "gd",
        },
        -- Show the prompt
        show_system_prompt = {
          normal = "gp",
        },
        -- Show the user selection
        show_user_selection = {
          normal = "gs",
        },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")

      -- Use unnamed register for the selection
      opts.selection = select.unnamed

      chat.setup(opts)

      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })

      -- Inline chat with Copilot
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", range = true })

      -- Restore CopilotChatBuffer
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true

          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
          end
        end,
      })
    end,
    event = "VeryLazy",
    keys = {
      -- Show help actions with telescope
      {
        "<leader>ah",
        function()
          local actions = require("CopilotChat.actions")
          local ok, telescope = pcall(require, "telescope")
          if ok then
            require("CopilotChat.integrations.telescope").pick(actions.help_actions())
          else
            vim.notify("Telescope not available", vim.log.levels.WARN)
          end
        end,
        desc = "CopilotChat - Help actions",
      },
      -- Show prompts actions with telescope
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          local ok, telescope = pcall(require, "telescope")
          if ok then
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
          else
            vim.notify("Telescope not available", vim.log.levels.WARN)
          end
        end,
        desc = "CopilotChat - Prompt actions",
      },
      {
        "<leader>ap",
        function()
          local ok, telescope = pcall(require, "telescope")
          if ok then
            vim.cmd(
              "lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))"
            )
          else
            vim.notify("Telescope not available", vim.log.levels.WARN)
          end
        end,
        mode = "x",
        desc = "CopilotChat - Prompt actions",
      },
      -- Code related commands
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
      -- Chat with Copilot in visual mode
      {
        "<leader>av",
        ":CopilotChatVisual",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<leader>ax",
        ":CopilotChatInline<cr>",
        mode = "x",
        desc = "CopilotChat - Inline chat",
      },
      -- Custom input for CopilotChat
      {
        "<leader>ai",
        function()
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then
            vim.cmd("CopilotChat " .. input)
          end
        end,
        desc = "CopilotChat - Ask input",
      },
      -- Generate commit message based on the git diff
      {
        "<leader>am",
        "<cmd>CopilotChatCommit<cr>",
        desc = "CopilotChat - Generate commit message for all changes",
      },
      {
        "<leader>aM",
        "<cmd>CopilotChatCommitStaged<cr>",
        desc = "CopilotChat - Generate commit message for staged changes",
      },
      -- Quick chat with Copilot
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CopilotChatBuffer " .. input)
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      -- Debug
      { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
      -- Fix the issue with diagnostic
      { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
      -- Clear buffer and chat history
      { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
      -- Toggle Copilot Chat Vsplit
      { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
      -- Copilot Chat Models
      { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
      -- Agent mode - direct fix in visual mode
      {
        "<leader>aA",
        function()
          local input = vim.fn.input("Agent Task: ")
          if input ~= "" then
            require("CopilotChat").ask(input, {
              selection = require("CopilotChat.select").visual,
            })
          end
        end,
        mode = "x",
        desc = "CopilotChat - Agent mode (visual)",
      },
      -- Agent mode - fix entire buffer
      {
        "<leader>aA",
        function()
          local input = vim.fn.input("Agent Task (whole buffer): ")
          if input ~= "" then
            require("CopilotChat").ask(input, {
              selection = require("CopilotChat.select").buffer,
            })
          end
        end,
        desc = "CopilotChat - Agent mode (buffer)",
      },
      -- Workspace agent - analyze entire codebase
      {
        "<leader>aW",
        function()
          local input = vim.fn.input("Workspace Task: ")
          if input ~= "" then
            -- Get all git files or fallback to current directory
            local select = require("CopilotChat.select")
            require("CopilotChat").ask(input, {
              selection = select.gitdiff,
              context = "buffers",
            })
          end
        end,
        desc = "CopilotChat - Workspace agent mode",
      },
      -- Ask with git diff context (all changes)
      {
        "<leader>ag",
        function()
          local input = vim.fn.input("Ask about git changes: ")
          if input ~= "" then
            require("CopilotChat").ask(input, {
              selection = require("CopilotChat.select").gitdiff,
            })
          end
        end,
        desc = "CopilotChat - Ask with git diff context",
      },
    },
  },
}

