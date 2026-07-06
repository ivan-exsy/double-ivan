# **Plan: Restore Original Reflection Trigger + Remove Fabricated Duration Fallback**

## *Context*

Survival mode sim 20260406-3 showed 6.1x throughput degradation (23 -> 83 LLM calls/step) over 960 steps. 
See `D:\Coding\generative_agents\environment\frontend_server\storage\20260406-3_report.md`

Root cause: commit ffd7b9e1 (Aug 2025) added an importance_ele_n >= 10 bypass to the reflection trigger that causes runaway reflection in chat-heavy sims. The same commit added a task decomposition fallback that injects 5-minute fabricated durations for unparseable LLM output, silently masking bad responses.

Both changes deviate from the Stanford paper's original design. We're reverting them.

Changes

     1. Remove ele_n >= 10 reflection bypass

     File: reverie/backend_server/persona/cognitive_modules/reflect.py (lines 572-576)

     Current:
       # Fixed logic: trigger when enough importance has been accumulated (counter goes low enough)
       # OR when we have accumulated significant importance elements
       if ((persona.scratch.importance_trigger_curr <= 0 or
            persona.scratch.importance_ele_n >= 10) and
           [] != persona.a_mem.seq_event + persona.a_mem.seq_thought):

     Change to:
       if (persona.scratch.importance_trigger_curr <= 0 and
           [] != persona.a_mem.seq_event + persona.a_mem.seq_thought):

     Restores the original Stanford paper logic: reflection fires only when the 150-point importance budget is depleted, not after an arbitrary count of 10 memory elements.

     2. Remove fabricated 5-minute duration fallback

     File: reverie/backend_server/persona/prompt_template/run_gpt_prompt.py (lines 840-850)

     Current:
             else:
               # Fallback: try to extract any reasonable task description
               # Remove numbering and clean up
               clean_line = line.strip()
               if clean_line.startswith(tuple(f"{i})" for i in range(1, 20))):
                 clean_line = " ".join(clean_line.split()[1:])  # Remove "N) " prefix

               # If we have a reasonable task description, assign a default duration
               if clean_line and len(clean_line) > 10 and not clean_line.lower().startswith("sleep"):
                 # Default to 5-minute increments for unspecified durations
                 cr += [[clean_line, 5]]

     Change to:
     Remove this entire else branch. Lines without (duration in minutes: format are skipped, matching the original behavior. The improved parsing in the if branch above (handling numbered formats,
      robust splitting) is kept.

     Files touched

     1. reverie/backend_server/persona/cognitive_modules/reflect.py — 3-line edit
     2. reverie/backend_server/persona/prompt_template/run_gpt_prompt.py — delete 10 lines

     Verification

     1. Run a short sim (50-100 steps) and confirm:
       - Reflection fires based on importance budget only (grep logs for REFLECTION: Starting reflection)
       - Reflection frequency should be low (~1 per 50 steps for mundane activity)
       - Task decomposition still produces valid schedules (no 5-min fabricated entries in logs)
     2. Check that importance_trigger_curr decrements naturally and resets to 150 after reflection
